//
//  TrailersDataModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import Foundation


struct ResponseTrailersData: Codable {
    var results: [TrailersDataModel]?
}

struct TrailersDataModel: Codable {
    let key: String
    let site: String
}
