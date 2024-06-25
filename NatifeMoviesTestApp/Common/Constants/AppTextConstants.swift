//
//  AppTextConstants.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 23.06.2024.
//

import Foundation

struct AppTextConstants {
    
    struct MainScreen {
        static let title = "Popular Movies"
        static let searchPlaceholder = "Search"
        
        struct ActionSheet {
            static let title = "Choose Option"
            static let noneTitle = "No sorting"
            static let popularTitle = "Popularity"
            static let ratingTitle = "Rating"
            static let adultTitle = "Adult"
            static let cancelTitle = "Cancel"
        }
    }
    
    struct Alert {
        static let okButtonTitle = "OK"
        static let noConnectionTitle = "No connection"
        static let noConnectionMessage = "You are offline. Please, enable your Wi-Fi or connect using cellular data."
        static let infoTitle = "Info"
        static let errorTitle = "Error"
    }
    
    struct Service {
        static let noData = "No Data"
    }
    
    struct DetailScreen {
        static let rating = "Rating: "
        static let noCountryTitle = "No country"
    }
}
