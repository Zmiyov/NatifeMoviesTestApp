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
    
    func getPopularMoviesList(completion: @escaping(Error?) -> Void) {
        repository.load(url: APIConfig.baseURL,
                        parameters: APIConfig.Parameters.defaultParameters,
                        headers: HTTPHeaders(APIConfig.Headers.defaultHeaders))
        { (response: ResponseList?, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let movieModelsArray = response?.results else {
                completion(error)
                return
            }
            
            print(movieModelsArray)
            completion(nil)
        }
    }
    
    
}
