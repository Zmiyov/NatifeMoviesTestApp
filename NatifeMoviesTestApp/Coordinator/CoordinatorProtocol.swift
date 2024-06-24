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
}
