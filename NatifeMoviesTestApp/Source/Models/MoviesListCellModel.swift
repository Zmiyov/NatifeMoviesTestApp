//
//  MoviesListCellModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

struct MoviesListCellModel: Hashable, Identifiable {
    let id: String
    let movieId: String
    let title: String
    let description: String
    let year: String
    let genres: String
    let popularity: String
    let rating: String
    let imageURL: String
    let country: String
    let adult: Bool
    
    var cellTitle: String {
        self.title + ", " + self.year
    }
    
    var fullImageURL: String {
        APIConfig.constructURLForEndpoint(endpoint: .image) + self.imageURL
    }
    
    init(movieId: String, title: String, description: String, year: String, genres: String, popularity: String, rating: String, imageURL: String, country: String, adult: Bool) {
        self.id = UUID().uuidString
        self.movieId = movieId
        self.title = title
        self.description = description
        self.year = year
        self.genres = genres
        self.popularity = popularity
        self.rating = rating
        self.imageURL = imageURL
        self.country = country
        self.adult = adult
    }
    
    init(movieEntity: MovieEntity) {
        self.id = movieEntity.id ?? ""
        self.movieId = movieEntity.movieId ?? ""
        self.title = movieEntity.title ?? ""
        self.description = movieEntity.movieDescription ?? ""
        self.year = movieEntity.year ?? ""
        self.genres = movieEntity.genres ?? ""
        self.popularity = movieEntity.popularity ?? ""
        self.rating = movieEntity.rating ?? ""
        self.imageURL = movieEntity.imageURL ?? ""
        self.country = movieEntity.country ?? ""
        self.adult = movieEntity.adult
    }
}
