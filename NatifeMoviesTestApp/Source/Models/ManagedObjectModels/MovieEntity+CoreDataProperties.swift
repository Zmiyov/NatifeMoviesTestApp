//
//  MovieEntity+CoreDataProperties.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 25.06.2024.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var movieId: String?
    @NSManaged public var title: String?
    @NSManaged public var movieDescription: String?
    @NSManaged public var year: String?
    @NSManaged public var genres: String?
    @NSManaged public var popularity: String?
    @NSManaged public var rating: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var country: String?
    @NSManaged public var adult: Bool
    
    func update(with cellModel: MoviesListCellModel) throws {
        self.id = cellModel.id
        self.movieId = cellModel.movieId
        self.title = cellModel.title
        self.movieDescription = cellModel.description
        self.year = cellModel.year
        self.genres = cellModel.genres
        self.popularity = cellModel.popularity
        self.rating = cellModel.rating
        self.imageURL = cellModel.imageURL
        self.country = cellModel.country
        self.adult = cellModel.adult
    }

}

extension MovieEntity : Identifiable {

}
