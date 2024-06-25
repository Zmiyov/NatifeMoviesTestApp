//
//  MainScreenViewController.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import UIKit


final class MainScreenViewController: UIViewController {
    
    private enum MainScreenCellIdentifiers: String {
        case moviesListCell
    }
    enum Section: CaseIterable {
        case main
    }
    
    var coordinator: MainCoordinator?
    var mainScreenViewModel: MainScreenViewModelProtocol
    
    private let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainScreenCellIdentifiers.moviesListCell.rawValue)
        return collectionView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MoviesListCellModel>!
    private var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section, MoviesListCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MoviesListCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mainScreenViewModel.filterdCellModels.value)
        return snapshot
    }
    
    private let refreshControl = UIRefreshControl()
    
    init(mainScreenViewModel: MainScreenViewModelProtocol) {
        self.mainScreenViewModel = mainScreenViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        configureView()
        configureCollectionView()
        configureSearchBar()
        bindViewModel()
        createDataSource()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        title = AppTextConstants.MainScreen.title.localized()
        searchBar.placeholder = AppTextConstants.MainScreen.searchPlaceholder.localized()
        let barButtonImage = UIImage(systemName: "menubar.arrow.down.rectangle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(openSortingOptionsList))
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    @objc
    private func openSortingOptionsList() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        configureActionSheet()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        
        guard ConnectionManager.shared.isConnected else {
            refreshControl.endRefreshing()
            AlertManager.shared.showNoConnectionAlert()
            return
        }
        
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                self.mainScreenViewModel.reloadData()
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func bindViewModel() {
        mainScreenViewModel.filterdCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateDataSource()
            }
        }
        
        mainScreenViewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.indicator.isHidden = false
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
        }
    }
    
    private func configureActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: AppTextConstants.MainScreen.ActionSheet.title.localized(), preferredStyle: .actionSheet)
        
        let noneButton = UIAlertAction(title: AppTextConstants.MainScreen.ActionSheet.noneTitle.localized(), style: .default, handler: { [weak self] _ in
            self?.mainScreenViewModel.sortOption = .none
            self?.scrollToTop()
        })
        noneButton.setValue(self.mainScreenViewModel.sortOption == .none, forKey: "checked")
        
        let popularButton = UIAlertAction(title: AppTextConstants.MainScreen.ActionSheet.popularTitle.localized(), style: .default, handler: { [weak self] _ in
            self?.mainScreenViewModel.sortOption = .popular
            self?.scrollToTop()
        })
        popularButton.setValue(self.mainScreenViewModel.sortOption == .popular, forKey: "checked")
        
        let ratingButton = UIAlertAction(title: AppTextConstants.MainScreen.ActionSheet.ratingTitle.localized(), style: .default, handler: { [weak self] _ in
            self?.mainScreenViewModel.sortOption = .rating
            self?.scrollToTop()
        })
        ratingButton.setValue(self.mainScreenViewModel.sortOption == .rating, forKey: "checked")

        let adultButton = UIAlertAction(title: AppTextConstants.MainScreen.ActionSheet.adultTitle.localized(), style: .default, handler: { [weak self] _ in
            self?.mainScreenViewModel.sortOption = .adult
            self?.scrollToTop()
        })
        adultButton.setValue(self.mainScreenViewModel.sortOption == .adult, forKey: "checked")

        let cancel = UIAlertAction(title: AppTextConstants.MainScreen.ActionSheet.cancelTitle.localized(), style: .cancel, handler: nil)

        optionMenu.addAction(noneButton)
        optionMenu.addAction(popularButton)
        optionMenu.addAction(ratingButton)
        optionMenu.addAction(adultButton)
        optionMenu.addAction(cancel)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func scrollToTop() {
        collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension MainScreenViewController {
    
    func createDataSource() {
        dataSource = EmptyableDiffableDataSource<Section, MoviesListCellModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCellIdentifiers.moviesListCell.rawValue, for: indexPath) as? MovieCollectionViewCell
            cell?.configure(with: movie)
            return cell
        }, emptyStateView: EmptyView())
    }
    
    func updateDataSource() {
        dataSource.apply(filteredItemsSnapshot)
    }
}

// MARK: - UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard ConnectionManager.shared.isConnected else {
            AlertManager.shared.showNoConnectionAlert()
            return
        }
        let model = mainScreenViewModel.filterdCellModels.value[indexPath.item]
        coordinator?.showDetail(for: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let text = searchBar.text, text.isEmpty else { return }
        
        let displayedMovieOrderNumber = indexPath.item + 1
        if displayedMovieOrderNumber % mainScreenViewModel.numberOfMoviesOnOnePage == 0 {
            
            let nextPageNumber = (displayedMovieOrderNumber / mainScreenViewModel.numberOfMoviesOnOnePage) + 1
            guard nextPageNumber <= mainScreenViewModel.totalPages, nextPageNumber > mainScreenViewModel.numberOfLoadedPage else { return }
            
            guard ConnectionManager.shared.isConnected else {
                AlertManager.shared.showNoConnectionAlert()
                return
            }
            
            mainScreenViewModel.numberOfLoadedPage = nextPageNumber
        }
    }
}

// MARK: - Set Constraints

extension MainScreenViewController {

    private func setConstraints() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 0),
            indicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 0)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mainScreenViewModel.searchText = searchText
        scrollToTop()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
