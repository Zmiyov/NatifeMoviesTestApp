//
//  MainCoordinator.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import UIKit
import YouTubePlayerKit

final class MainCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MainScreenViewModel()
        let mainViewController = MainScreenViewController(mainScreenViewModel: viewModel)
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func showDetail(for model: MoviesListCellModel) {
        let detailViewModel = DetailScreenViewModel(model: model)
        let detailViewController = DetailScreenViewController(viewModel: detailViewModel)
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: false)
    }
    
    func showZoomViewController(image: UIImage) {
        let zoomVC = ZoomViewController(image: image)
        navigationController.present(zoomVC, animated: true)
    }
    
    func showTrailerVideo(fullVideoURL: String) {
        let youTubePlayerViewController = YouTubePlayerViewController(player: YouTubePlayer(stringLiteral: fullVideoURL))
        navigationController.pushViewController(youTubePlayerViewController, animated: false)
    }
}
