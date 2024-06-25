//
//  MainScreenViewModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation

enum SortOption {
    case none
    case popular
    case rating
    case adult
}

protocol MainScreenViewModelProtocol {
    var filterdCellModels: Dynamic<[MoviesListCellModel]> { get }
    var isLoading: Dynamic<Bool> { get }
    var totalPages: Int { get }
    var numberOfMoviesOnOnePage: Int { get }
    var numberOfLoadedPage: Int { get set }
    var sortOption: SortOption { get set }
    var searchText: String { get set }
    
    var title: String { get }
    var searchPlaceholder: String { get }
    var actionSheetTitle: String { get }
    var noActionTitle: String { get }
    var popularActionTitle: String { get }
    var ratingActionTitle: String { get }
    var adultActionTitle: String { get }
    var cancelActionTitle: String { get }
    
    func reloadData()
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    private let dataProvider = DataProvider(repository: APIManager.shared)
    
    private var modelsArray: [PopularFilmModel] = []
    private var genresArray: [GenresModel] = []
    
    private var cellModels: [MoviesListCellModel] = []
    private(set) var filterdCellModels = Dynamic([MoviesListCellModel]())
    private(set) var isLoading = Dynamic(Bool())
    
    private(set) var totalPages = 500
    private(set) var numberOfMoviesOnOnePage = 20
    var numberOfLoadedPage: Int = 1 {
        didSet {
            guard cellModels.count / 20 < numberOfLoadedPage else { return }
            Task {
                await loadData(numberOfLoadedPage: numberOfLoadedPage)
                sortFilteredMoviesModels()
            }
        }
    }
    
    var sortOption: SortOption = .none {
        didSet {
            sortFilteredMoviesModels()
        }
    }
    
    var searchText: String = "" {
        didSet {
            filterMoviesModels(text: searchText)
        }
    }
    
    var title: String { AppTextConstants.MainScreen.title.localized() }
    var searchPlaceholder: String { AppTextConstants.MainScreen.searchPlaceholder.localized() }
    var actionSheetTitle: String { AppTextConstants.MainScreen.ActionSheet.title.localized() }
    var noActionTitle: String { AppTextConstants.MainScreen.ActionSheet.noneTitle.localized() }
    var popularActionTitle: String { AppTextConstants.MainScreen.ActionSheet.popularTitle.localized() }
    var ratingActionTitle: String { AppTextConstants.MainScreen.ActionSheet.ratingTitle.localized() }
    var adultActionTitle: String { AppTextConstants.MainScreen.ActionSheet.adultTitle.localized() }
    var cancelActionTitle: String { AppTextConstants.MainScreen.ActionSheet.cancelTitle.localized() }
    
    init() {
        Task {
            await loadData(numberOfLoadedPage: numberOfLoadedPage)
            sortFilteredMoviesModels()
        }
    }
    
    private func loadMoviesListData(page: String) async -> [PopularFilmModel] {
        await withCheckedContinuation { continuation in
            dataProvider.getPopularMoviesList(page: page) { moviesArray, error in
                if let error {
                    print(error.localizedDescription)
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let moviesArray else {
                    print("There are no movies data")
                    return
                }
                continuation.resume(returning: moviesArray)
            }
        }
    }
    
    private func loadGenresData() async -> [GenresModel] {
        await withCheckedContinuation { continuation in
            dataProvider.getGenresList { genresArray, error in
                if let error {
                    print(error.localizedDescription)
                    AlertManager.shared.showErrorAlert(error: error)
                    return
                }
                
                guard let genresArray else {
                    print("There are no data")
                    return
                }
                continuation.resume(returning: genresArray)
            }
        }
    }
    
    private func loadData(numberOfLoadedPage: Int) async {
        isLoading.value = true
        let loadedModels = await loadMoviesListData(page: String(numberOfLoadedPage))
        self.modelsArray = self.modelsArray + loadedModels
        self.genresArray = await loadGenresData()
        isLoading.value = false
        
        self.cellModels = modelsArray.map{
            MoviesListCellModel(movieId: $0.id, 
                                title: $0.title,
                                description: $0.overview,
                                year: extractYearFromStringDate(date: $0.releaseDate),
                                genres: convertIdsToGenres(ids: $0.genreIds),
                                popularity: String($0.popularity), 
                                rating: String($0.voteAverage),
                                imageURL: $0.posterPath, 
                                country: $0.originalLanguage,
                                adult: $0.adult)
        }
    }
    
    private func convertIdsToGenres(ids: [Int]) -> String {
        let genres = genresArray.filter{ ids.contains($0.id) }.map{ $0.name }
        return genres.joined(separator: ", ")
    }
    
    private func extractYearFromStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: date) else { return "No data".localized() }
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        return year
    }
    
    private func filterMoviesModels(text: String) {
        if text.isEmpty {
            self.filterdCellModels.value = cellModels
        } else {
            self.filterdCellModels.value = cellModels.filter{ $0.title.contains(text) }
        }
    }
    
    private func sortFilteredMoviesModels() {
        filterMoviesModels(text: searchText)
        let filteredModels = filterdCellModels.value
        switch sortOption {
        case .none:
            break
        case .popular:
            filterdCellModels.value = filteredModels.sorted(by: { model1, model2 in
                guard let lhs = Double(model1.popularity), let rhs = Double(model2.popularity) else { return false }
                return lhs > rhs
            })
        case .rating:
            filterdCellModels.value = filteredModels.sorted(by: { model1, model2 in
                guard let lhs = Double(model1.rating), let rhs = Double(model2.rating) else { return false }
                return lhs > rhs
            })
        case .adult:
            filterdCellModels.value = filteredModels.filter{ $0.adult}
        }
    }
    
    func reloadData() {
        self.modelsArray = []
        self.genresArray = []
        self.cellModels = []
        self.filterdCellModels.value = []
        self.numberOfLoadedPage = 1
    }
}
