//
//  MainScreenViewModel.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import Foundation
import CoreData

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
    
    private let dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.storeContainer, repository: APIManager.shared)
    
    lazy var fetchedResultsController: NSFetchedResultsController<MovieEntity> = {
        let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return controller
    }()
    
    private var cellModels: [MoviesListCellModel] = []
    private(set) var filterdCellModels = Dynamic([MoviesListCellModel]())
    private(set) var isLoading = Dynamic(Bool())
    
    private(set) var totalPages = 500
    private(set) var numberOfMoviesOnOnePage = 20
    var numberOfLoadedPage: Int = 1 {
        didSet {
            guard cellModels.count / 20 < numberOfLoadedPage else { return }
            Task {
                await dataProvider.syncMovieCellModels(page: numberOfLoadedPage)
                fetchMoviesModels()
            }
        }
    }
    
    var sortOption: SortOption = .popular {
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
            await dataProvider.syncMovieCellModels(page: numberOfLoadedPage)
            fetchMoviesModels()
        }
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
        self.cellModels = []
        self.filterdCellModels.value = []
        self.numberOfLoadedPage = 1
    }
    
    func fetchMoviesModels() {
        self.cellModels = []
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        if let coreDataCellModels = fetchedResultsController.fetchedObjects {
            let cellModels = coreDataCellModels.map({ MoviesListCellModel(movieEntity: $0) })
            self.cellModels = cellModels
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.sortFilteredMoviesModels()
            }
        }
    }
}
