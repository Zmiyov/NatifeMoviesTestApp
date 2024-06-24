//
//  SceneDelegate.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let navController = UINavigationController()
        mainCoordinator = MainCoordinator(navigationController: navController)
        mainCoordinator?.start()
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

}

