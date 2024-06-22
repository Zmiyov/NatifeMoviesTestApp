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
    
    func getPopularMoviesList(completion: @escaping([PopularFilmModel]?, Error?) -> Void) {
        repository.load(url: APIConfig.baseMoviesListURL,
                        parameters: APIConfig.MoviesListParameters.defaultParameters,
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
        repository.load(url: APIConfig.baseMoviesGenresURL,
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
}
