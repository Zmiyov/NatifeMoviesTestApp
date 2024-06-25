//
//  PopularFilmModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import Foundation

struct ResponseMoviesList: Codable {
    var results: [PopularFilmModel]?
}

struct PopularFilmModel: Codable, Hashable {
    let adult: Bool
    let backdropPath: String
    let genreIds:[Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
