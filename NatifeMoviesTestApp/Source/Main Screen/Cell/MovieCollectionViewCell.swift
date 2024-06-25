//
//  MovieCollectionViewCell.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .bold))
    private let genresLabel = UILabel(font: UIFont.systemFont(ofSize: 15, weight: .semibold))
    private let ratingLabel = UILabel(font: UIFont.systemFont(ofSize: 13, weight: .regular), alighment: .right)
    
    private let containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        genresLabel.text = nil
        ratingLabel.text = nil
        gradientLayer.removeFromSuperlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.drawShadow()
    }
    
    func configure(with movie: MoviesListCellModel) {
        self.titleLabel.text = movie.cellTitle
        self.genresLabel.text = movie.genres
        self.ratingLabel.text = movie.popularity
        self.imageView.loadImage(URL(string: movie.fullImageURL)) { [weak self] in
            self?.setupGradient()
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        genresLabel.numberOfLines = 3
    }
    
    private func setupGradient() {
        gradientLayer.frame = self.imageView.bounds
        
        gradientLayer.colors = [
            UIColor.black.cgColor,  // 25% Black
            UIColor.clear.cgColor,  // 50% Clear
            UIColor.clear.cgColor,  // 50% Clear
            UIColor.black.cgColor   // 25% Black
        ]
        
        gradientLayer.locations = [
            0.0,   // Start of gradient
            0.25,  // 25% point
            0.75,  // 75% point
            1.0    // End of gradient
        ]
        
        self.imageView.layer.addSublayer(gradientLayer)
        imageView.bringSubviewToFront(titleLabel)
        imageView.bringSubviewToFront(genresLabel)
        imageView.bringSubviewToFront(ratingLabel)
    }
    
    private func setConstraints() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
        ])

        imageView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15)
        ])

        imageView.addSubview(genresLabel)
        NSLayoutConstraint.activate([
            genresLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            genresLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15)
        ])

        imageView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            ratingLabel.leadingAnchor.constraint(equalTo: genresLabel.trailingAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            ratingLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
        
        
    }
}
