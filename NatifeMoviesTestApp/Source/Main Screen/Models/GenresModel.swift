//
//  GenresModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

struct ResponseGenresList: Codable {
    var genres: [GenresModel]?
}

struct GenresModel: Codable {
    let id: Int
    let name: String
}
