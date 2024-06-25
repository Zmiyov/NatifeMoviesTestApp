//
//  DetailScreenViewModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import Foundation


protocol DetailScreenViewModelProtocol {
    var model: MoviesListCellModel { get }
    var youTubeKey: Dynamic<String> { get }
    
    func getCountryAndYear() async -> String
}

final class DetailScreenViewModel: DetailScreenViewModelProtocol {
    
    private(set) var model: MoviesListCellModel
    private(set) var youTubeKey = Dynamic(String())
    
    private let dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.storeContainer, repository: APIManager.shared)
    
    init(model: MoviesListCellModel) {
        self.model = model
        
        Task {
            await getTrailerURL()
        }
    }
    
    private func getMovieCountry(movie id: String) async -> String? {
        await withCheckedContinuation { continuation in
            dataProvider.getMovieCountry(movieID: id) { detailsModel, error in
                if let error {
                    print(error.localizedDescription)
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let detailsModel else {
                    print("There are no details data")
                    return
                }
                
                let countryCodes = detailsModel.originCountry
                let locale = Locale.current
                var countriesString: [String] = []
                for code in countryCodes {
                    let countryName = locale.localizedString(forRegionCode: code)
                    if let countryName {
                        countriesString.append(countryName)
                    }
                }
                continuation.resume(returning: countriesString.joined(separator: ", "))
            }
        }
    }
    
    private func getTrailersData(movie id: String) async -> [TrailersDataModel] {
        await withCheckedContinuation { continuation in
            dataProvider.getMovieTrailer(movieID: id) { trailersDataArray, error in
                if let error {
                    print(error.localizedDescription)
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let trailersDataArray else {
                    print("There are no trailers data")
                    return
                }
                
                continuation.resume(returning: trailersDataArray)
            }
        }
    }
    
    private func getTrailerURL() async {
        let trailersData = await getTrailersData(movie: String(model.movieId))
        if let youTubeKey = trailersData.filter({ $0.site == "YouTube" }).map({ $0.key }).first {
            self.youTubeKey.value = youTubeKey
        }
    }
    
    func getCountryAndYear() async -> String {
        let country = await getMovieCountry(movie: String(model.movieId))
        return (country ?? AppTextConstants.DetailScreen.noCountryTitle.localized()) + ", " + model.year
    }
    
}
