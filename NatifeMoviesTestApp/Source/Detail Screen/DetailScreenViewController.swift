//
//  DetailScreenViewController.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import UIKit
import YouTubePlayerKit

final class DetailScreenViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    let detailViewModel: DetailScreenViewModelProtocol
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let bottomContainerView: UIView = {
        var view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold), color: .black)
    private let countryAndYearLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold), color: .black)
    private let genresLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold), color: .black)
    private let ratingLabel = UILabel(font: UIFont.systemFont(ofSize: 15, weight: .bold), alighment: .right, color: .black)
    private let descriptionLabel = UILabel(font: UIFont.systemFont(ofSize: 13, weight: .regular), color: .black)
    
    private let openTrailerButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "videoButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    init(viewModel: DetailScreenViewModelProtocol) {
        self.detailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setConstraints()
        setupViews()
        setupLabels()
        setupButton()
        setupImageViewAction()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = detailViewModel.model.title
        imageView.loadImage(URL(string: detailViewModel.model.fullImageURL))
    }
    
    private func setupLabels() {
        descriptionLabel.numberOfLines = 0
        
        Task {
            countryAndYearLabel.text = await detailViewModel.getCountryAndYear()
            nameLabel.text = detailViewModel.model.title
            genresLabel.text = detailViewModel.model.genres
            ratingLabel.text = AppTextConstants.DetailScreen.rating + detailViewModel.model.rating
            descriptionLabel.text = detailViewModel.model.description
        }
    }
    
    private func setupButton() {
        openTrailerButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        updateOpenVideoButtonState()
    }
    
    private func setupImageViewAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func videoButtonTapped() {
        let urlString = APIConfig.constructURLForEndpoint(endpoint: .youTube(detailViewModel.youTubeKey.value))
        coordinator?.showTrailerVideo(fullVideoURL: urlString)
    }
    
    @objc
    func imageTapped() {
        guard let image = imageView.image else { return }
        coordinator?.showZoomViewController(image: image)
    }
    
    private func bindViewModel() {
        detailViewModel.youTubeKey.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateOpenVideoButtonState()
            }
        }
    }
    
    private func updateOpenVideoButtonState() {
        openTrailerButton.isHidden = detailViewModel.youTubeKey.value.isEmpty
    }

    private func setConstraints() {

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
        
        contentStackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5)
        ])
        
        contentStackView.addArrangedSubview(bottomContainerView)

        bottomContainerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])

        bottomContainerView.addSubview(countryAndYearLabel)
        NSLayoutConstraint.activate([
            countryAndYearLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            countryAndYearLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            countryAndYearLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        bottomContainerView.addSubview(genresLabel)
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: countryAndYearLabel.bottomAnchor, constant: 15),
            genresLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            genresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        bottomContainerView.addSubview(openTrailerButton)
        NSLayoutConstraint.activate([
            openTrailerButton.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 15),
            openTrailerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            openTrailerButton.heightAnchor.constraint(equalToConstant: 35),
            openTrailerButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        bottomContainerView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ratingLabel.centerYAnchor.constraint(equalTo: openTrailerButton.centerYAnchor)
        ])
        
        bottomContainerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: openTrailerButton.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -15)
        ])
    }
}
