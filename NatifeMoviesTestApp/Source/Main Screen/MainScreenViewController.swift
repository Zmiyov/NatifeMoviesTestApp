//
//  MainScreenViewController.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    var mainScreenViewModel: MainScreenViewModel
    
    let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search".localized()
        return searchBar
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: CellIdentifiers.moviesListCell.rawValue)
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MoviesListCellModel>!
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section, MoviesListCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MoviesListCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mainScreenViewModel.filterdCellModels.value)
        return snapshot
    }
    
    private let refreshControl = UIRefreshControl()
    
    private enum CellIdentifiers: String {
        case moviesListCell
    }
    enum Section: CaseIterable {
        case main
    }
    
    init(mainScreenViewModel: MainScreenViewModel) {
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
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.createDataSource()
        }
        refreshControl.endRefreshing()
    }
    
    private func configureView() {
        title = mainScreenViewModel.title
        view.backgroundColor = .white
        let barButtonImage = UIImage(systemName: "menubar.arrow.down.rectangle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(openSortingOptionsList))
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    @objc
    private func openSortingOptionsList() {
        
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func bindViewModel() {
        mainScreenViewModel.filterdCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateDataSource()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainScreenViewController {
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MoviesListCellModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.moviesListCell.rawValue, for: indexPath) as? MovieCollectionViewCell
            cell?.configure(with: movie)
            return cell
        })
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

    }
}

// MARK: - Set Constraints

extension MainScreenViewController {

    private func setConstraints() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mainScreenViewModel.searchText = searchText
    }
}
