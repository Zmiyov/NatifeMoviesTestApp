//
//  DataProvider.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation
import Alamofire

final class DataProvider {
    
    private let repository: APIManager
    
    init(repository: APIManager) {
        self.repository = repository
    }
    
    func getPopularMoviesList(page: String, completion: @escaping([PopularFilmModel]?, Error?) -> Void) {
        
        repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .list),
                        parameters: APIConfig.MoviesListParameters.makeMovieListParameters(page: page),
                        headers: HTTPHeaders(APIConfig.MoviesListHeaders.defaultHeaders))
        { (response: ResponseMoviesList?, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let movieModelsArray = response?.results else {
                completion(nil, error)
                return
            }

            completion(movieModelsArray, nil)
        }
    }
    
    func getGenresList(completion: @escaping([GenresModel]?, Error?) -> Void) {
        repository.load(url: APIConfig.constructURLForEndpoint(endpoint: .genres),
                        parameters: APIConfig.MoviesGenresParameters.defaultParameters,
                        headers: HTTPHeaders(APIConfig.MoviesGenresHeaders.defaultHeaders))
        { (response: ResponseGenresList?, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let movieModelsArray = response?.genres else {
                completion(nil, error)
                return
            }

            completion(movieModelsArray, nil)
        }
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
}
