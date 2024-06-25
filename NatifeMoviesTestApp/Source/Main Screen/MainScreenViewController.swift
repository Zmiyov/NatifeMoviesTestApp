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
        title = mainScreenViewModel.title
        searchBar.placeholder = mainScreenViewModel.searchPlaceholder
        view.backgroundColor = .white
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
        let optionMenu = UIAlertController(title: nil, message: mainScreenViewModel.actionSheetTitle, preferredStyle: .actionSheet)
        
        let noneButton = UIAlertAction(title: mainScreenViewModel.noActionTitle, style: .default, handler: { [unowned self] _ in
            self.mainScreenViewModel.sortOption = .none
        })
        noneButton.setValue(self.mainScreenViewModel.sortOption == .none, forKey: "checked")
        
        let popularButton = UIAlertAction(title: mainScreenViewModel.popularActionTitle, style: .default, handler: { [unowned self] _ in
            self.mainScreenViewModel.sortOption = .popular
        })
        popularButton.setValue(self.mainScreenViewModel.sortOption == .popular, forKey: "checked")
        
        let ratingButton = UIAlertAction(title: mainScreenViewModel.ratingActionTitle, style: .default, handler: { [unowned self] _ in
            self.mainScreenViewModel.sortOption = .rating
        })
        ratingButton.setValue(self.mainScreenViewModel.sortOption == .rating, forKey: "checked")

        let adultButton = UIAlertAction(title: mainScreenViewModel.adultActionTitle, style: .default, handler: { [unowned self] _ in
            self.mainScreenViewModel.sortOption = .adult
        })
        adultButton.setValue(self.mainScreenViewModel.sortOption == .adult, forKey: "checked")

        let cancel = UIAlertAction(title: mainScreenViewModel.cancelActionTitle, style: .cancel, handler: nil)

        optionMenu.addAction(noneButton)
        optionMenu.addAction(popularButton)
        optionMenu.addAction(ratingButton)
        optionMenu.addAction(adultButton)
        optionMenu.addAction(cancel)
        self.present(optionMenu, animated: true, completion: nil)
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
        updateDataSource()
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
            guard nextPageNumber <= mainScreenViewModel.totalPages else { return }
            
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
