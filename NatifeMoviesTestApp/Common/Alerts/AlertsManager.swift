//
//  AlertsManager.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 25.06.2024.
//

import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(title: String, message: String) {
        guard let topViewController = getTopViewController() else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.modalTransitionStyle = .crossDissolve
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showNoConnectionAlert() {
        showAlert(title: "No connection".localized(), message: "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized())
    }
    
    func showConnectionAlert() {
        showAlert(title: "Connection Available".localized(), message: "Internet connection is now reachable.".localized())
    }
    
    func showInfoAlert(message: String) {
        showAlert(title: "Info".localized(), message: message.localized())
    }
    
    func showErrorAlert(error: Error) {
        showAlert(title: "Error".localized(), message: error.localizedDescription)
    }

    
    //MARK: - Get Top ViewController For Presenting
    
    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first as? UIWindowScene else {
            return nil
        }
        
        guard let rootViewController = windowScene.windows
                .filter({ $0.isKeyWindow }).first?.rootViewController else {
            return nil
        }
        
        return getTopViewController(from: rootViewController)
    }

    private func getTopViewController(from rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return getTopViewController(from: visibleViewController)
        }
        
        if let tabBarController = rootViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return getTopViewController(from: selectedViewController)
        }
        
        return rootViewController
    }
}
