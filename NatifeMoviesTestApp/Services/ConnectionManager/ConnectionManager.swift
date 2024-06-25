//
//  ConnectionManager.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 25.06.2024.
//

import UIKit
import Network
import Reachability

final class ConnectionManager {
    
    private let reachability = try! Reachability()
    
    var isConnected: Bool = true
    static let shared = ConnectionManager()
    
    func startConnectionMonitoring() {

        reachability.whenReachable = { _ in
            self.isConnected = true
        }
        
        reachability.whenUnreachable = { _ in
            self.isConnected = false
            AlertManager.shared.showNoConnectionAlert()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}
