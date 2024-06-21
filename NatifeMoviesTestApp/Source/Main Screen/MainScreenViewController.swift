//
//  MainScreenViewController.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    let dataProvider = DataProvider(repository: APIManager.shared)
    
    
    override func loadView() {
        super.loadView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    private func loadData() {
        dataProvider.getPopularMoviesList { _ in
            
        }
    }
}
