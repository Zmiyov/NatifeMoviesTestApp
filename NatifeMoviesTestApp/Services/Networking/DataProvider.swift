//
//  DataProvider.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation
import Alamofire
import CoreData

final class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: APIManager
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var genresArray: [GenresModel] = []
    
    init(persistentContainer: NSPersistentContainer, repository: APIManager) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func getMovieCountry(movieID: String, completion: @escaping(MovieDetailsModel?, Error?) -> Void) {
        repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .countries(movieID)),
                        parameters: APIConfig.MoviesDetailsParameters.defaultParameters,
                        headers: HTTPHeaders(APIConfig.MoviesDetailsParameters.defaultHeaders))
        { (response: MovieDetailsModel?, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let movieDetails = response else {
                completion(nil, error)
                return
            }
            
            completion(movieDetails, nil)
        }
    }
    
    func getMovieTrailer(movieID: String, completion: @escaping([TrailersDataModel]?, Error?) -> Void) {
        repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .trailers(movieID)),
                        parameters: APIConfig.MoviesTrailesDataParameters.defaultParameters,
                        headers: HTTPHeaders(APIConfig.MoviesTrailesDataParameters.defaultHeaders))
        { (response: ResponseTrailersData?, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let trailersData = response?.results else {
                completion(nil, error)
                return
            }
            
            completion(trailersData, nil)
        }
    }
    
    
    private func getPopularMoviesList(page: String) async -> [PopularFilmModel] {
        await withCheckedContinuation { continuation in
            repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .list),
                            parameters: APIConfig.MoviesListParameters.makeMovieListParameters(page: page),
                            headers: HTTPHeaders(APIConfig.MoviesListHeaders.defaultHeaders))
            { (response: ResponseMoviesList?, error) in
                
                if let error = error {
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let movieModelsArray = response?.results else {
                    print("No list data")
                    return
                }
                continuation.resume(returning: movieModelsArray)
            }
        }
    }
    
    private func getGenresList() async -> [GenresModel] {
        await withCheckedContinuation { continuation in
            repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .genres),
                            parameters: APIConfig.MoviesGenresParameters.defaultParameters,
                            headers: HTTPHeaders(APIConfig.MoviesGenresHeaders.defaultHeaders))
            { (response: ResponseGenresList?, error) in
                
                if let error = error {
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let movieGenresArray = response?.genres else {
                    print("No genres data")
                    return
                }
                
                continuation.resume(returning: movieGenresArray)
            }
        }
    }
}

//MARK: - Cache data
extension DataProvider {
    func syncMovieCellModels(at page: Int) async {
        let loadedModels = await getPopularMoviesList(page: String(page))
        self.genresArray = await getGenresList()
        
        let cellModels = loadedModels.map{
            MoviesListCellModel(movieId: String($0.id),
                                title: $0.title,
                                description: $0.overview,
                                year: extractYearFromStringDate(date: $0.releaseDate),
                                genres: convertIdsToGenres(ids: $0.genreIds),
                                popularity: String($0.popularity),
                                rating: String($0.voteAverage),
                                imageURL: $0.posterPath,
                                country: $0.originalLanguage,
                                adult: $0.adult)
        }
        
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        saveNewModels(models: cellModels, context: taskContext)
    }
    
    private func convertIdsToGenres(ids: [Int]) -> String {
        let genres = genresArray.filter{ ids.contains($0.id) }.map{ $0.name }
        return genres.joined(separator: ", ")
    }
    
    private func extractYearFromStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: date) else { return AppTextConstants.Service.noData.localized() }
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        return year
    }
    
    private func saveNewModels(models: [MoviesListCellModel], context: NSManagedObjectContext) {
        for modelData in models {
            let id = modelData.movieId

            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "movieId == %@", id)

            do {
                let results = try context.fetch(fetchRequest)
                if results.isEmpty {
                    guard let cellModelEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity",
                                                                                   into: context) as? MovieEntity else {
                        print("Error: Failed to create a new Movie object!")
                        return
                    }
                    
                    do {
                        try cellModelEntity.update(with: modelData)
                    } catch {
                        print("Error: \(error)\nThe Movie object will be deleted.")
                        context.delete(cellModelEntity)
                    }
                }
            } catch {
                print("Fetch request failed: \(error.localizedDescription)")
            }
        }

        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
