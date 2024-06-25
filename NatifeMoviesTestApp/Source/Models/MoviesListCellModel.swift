//
//  MoviesListCellModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

struct MoviesListCellModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let movieId: Int
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
}
