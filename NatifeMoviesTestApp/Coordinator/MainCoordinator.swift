//
//  MainCoordinator.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import UIKit

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

    func showDetail() {

    }
}
