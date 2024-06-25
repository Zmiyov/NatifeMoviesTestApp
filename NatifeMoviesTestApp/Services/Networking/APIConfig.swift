//
//  APIConfig.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation

struct APIConfig {
    enum EndPoints {
        case list
        case image
        case genres
        case countries(String)
        case trailers(String)
        case youTube(String)
    }
    
    static func constructURLForEndpoint(endpoint: EndPoints) -> String {
        switch endpoint {
        case .list:
            return "https://api.themoviedb.org/3/movie/popular"
        case .image:
            return "https://image.tmdb.org/t/p/w500"
        case .genres:
            return "https://api.themoviedb.org/3/genre/movie/list"
        case .countries(let id):
            return "https://api.themoviedb.org/3/movie/\(id)"
        case .trailers(let id):
            return "https://api.themoviedb.org/3/movie/\(id)/videos"
        case .youTube(let key):
            return "https://www.youtube.com/watch?v=\(key)"
        }
    }
    
    //MARK: - For List of movies
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
            let parameters = [
                "language": "en-US",
                "page": page
            ]
            return parameters
        }
    }
    
    //MARK: - For Genres
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
    
    //MARK: - For Movie Details
    struct MoviesDetailsParameters {
        static let defaultHeaders: [String: String] = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]
        
        static let defaultParameters: [String: String] = [
            "language": "en-US"
        ]
    }
    
    //MARK: - For Movie Trailers Data
    struct MoviesTrailesDataParameters {
        static let defaultHeaders: [String: String] = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]
        
        static let defaultParameters: [String: String] = [
            "language": "en-US"
        ]
    }
}
