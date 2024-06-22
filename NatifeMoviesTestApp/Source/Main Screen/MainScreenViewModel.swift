//
//  MainScreenViewModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

final class MainScreenViewModel {
    
    private let dataProvider = DataProvider(repository: APIManager.shared)
    
    private var modelsArray: [PopularFilmModel] = []
    private var genresArray: [GenresModel] = []
    
    private var cellModels: [MoviesListCellModel] = []
    var filterdCellModels = Dynamic([MoviesListCellModel]())
    
    private enum TextLabels: String {
        case title = "Popular Movies"
    }
    
    var title: String {
        TextLabels.title.rawValue.localized()
    }
    
    var searchText: String = "" {
        didSet {
            filterMoviesModels(text: searchText)
        }
    }
    
    private var numberOfLoadedPages: Int = 1
    
    init() {
        Task {
            await loadData()
            filterMoviesModels(text: searchText)
        }
    }
    
    private func loadMoviesListData(page: String) async -> [PopularFilmModel] {
        await withCheckedContinuation { continuation in
            dataProvider.getPopularMoviesList { moviesArray, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let moviesArray else {
                    print("There are no data".localized())
                    return
                }
                continuation.resume(returning: moviesArray)
            }
        }
    }
    
    private func loadGenresData() async -> [GenresModel] {
        await withCheckedContinuation { continuation in
            dataProvider.getGenresList { genresArray, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let genresArray else {
                    print("There are no data".localized())
                    return
                }
                continuation.resume(returning: genresArray)
            }
        }
    }
    
    private func loadData() async {
        let loadedModels = await loadMoviesListData(page: String(numberOfLoadedPages))
        self.modelsArray = self.modelsArray + loadedModels
        self.genresArray = await loadGenresData()
        
        self.cellModels = modelsArray.map{
            MoviesListCellModel(title: $0.title,
                                year: extractYearFromStringDate(date: $0.release_date),
                                genres: convertIdsToGenres(ids: $0.genre_ids),
                                rating: String($0.popularity),
                                imageURL: $0.poster_path)
        }
    }
    
    private func convertIdsToGenres(ids: [Int]) -> String {
        let genres = genresArray.filter{ ids.contains($0.id) }.map{ $0.name }
        return genres.joined(separator: ", ")
    }
    
    private func extractYearFromStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: date) else { return "No data".localized() }
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        return year
    }
    
    func filterMoviesModels(text: String) {
        if text.isEmpty {
            self.filterdCellModels.value = cellModels
        } else {
            self.filterdCellModels.value = cellModels.filter{ $0.title.contains(text) }
        }
    }
}
