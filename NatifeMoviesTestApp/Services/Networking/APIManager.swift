//
//  ApiManager.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation
import Alamofire

final class APIManager {

    static let shared = APIManager()
    
    func load<T: Decodable>(url: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (T?, Error?) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: T.self, decoder: decoder) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
}
