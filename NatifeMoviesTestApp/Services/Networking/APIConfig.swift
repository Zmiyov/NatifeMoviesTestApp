//
//  APIConfig.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation

struct APIConfig {
    static let baseMoviesListURL = "https://api.themoviedb.org/3/movie/popular"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let baseMoviesGenresURL = "https://api.themoviedb.org/3/genre/movie/list"
    
    struct MoviesListHeaders {
        static let defaultHeaders: [String: String] = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]
    }
    
    struct MoviesListParameters {
        static let defaultParameters: [String: String] = [
            "language": "en-US",
            "page": "1"
        ]
        
        static func makeMovieListParameters(page: String) -> [String: String] {
            var parameters = [
                "language": "en-US",
                "page": page
            ]
            return parameters
        }
    }
    
    struct MoviesGenresHeaders {
        static let defaultHeaders: [String: String] = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]
    }
    
    struct MoviesGenresParameters {
        static let defaultParameters: [String: String] = [
            "language": "en"
        ]
    }
}
