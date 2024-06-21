//
//  APIConfig.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation

struct APIConfig {
    static let baseURL = "https://api.themoviedb.org/3/movie/popular"
    
    struct Headers {
        static let defaultHeaders: [String: String] = [
            "Accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]
    }
    
    struct Parameters {
        static let defaultParameters: [String: String] = [
            "language": "en-US",
            "page": "1"
        ]
    }
}
