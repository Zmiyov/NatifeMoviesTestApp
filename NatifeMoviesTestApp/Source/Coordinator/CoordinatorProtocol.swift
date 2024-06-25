//
//  CoordinatorProtocol.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func start()
    func showDetail(for model: MoviesListCellModel)
    func showZoomViewController(image: UIImage)
    func showTrailerVideo(fullVideoURL: String)
}
