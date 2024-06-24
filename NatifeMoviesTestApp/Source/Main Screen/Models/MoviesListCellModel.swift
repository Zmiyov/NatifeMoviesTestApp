//
//  MoviesListCellModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

struct MoviesListCellModel: Hashable {
    let title: String
    let year: String
    let genres: String
    let popularity: String
    let rating: String
    let imageURL: String
    let adult: Bool
    
    var cellTitle: String {
        self.title + ", " + self.year
    }
    
    var fullImageURL: String {
        APIConfig.baseImageURL + self.imageURL
    }
}
