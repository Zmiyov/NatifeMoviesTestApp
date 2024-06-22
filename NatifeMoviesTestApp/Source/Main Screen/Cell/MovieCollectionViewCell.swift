//
//  MovieCollectionViewCell.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .bold))
    let genresLabel = UILabel(font: UIFont.systemFont(ofSize: 15, weight: .semibold))
    let ratingLabel = UILabel(font: UIFont.systemFont(ofSize: 13, weight: .regular), alighment: .right)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(cgColor: CGColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        imageView.image = nil
    }
    
    func configure(with movie: MoviesListCellModel) {
        self.titleLabel.text = movie.cellTitle
        self.genresLabel.text = movie.genres
        self.ratingLabel.text = movie.rating
        self.imageView.kf.setImage(with: URL(string: movie.fullImageURL))
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        backgroundColor = .tertiarySystemBackground
        genresLabel.numberOfLines = 3

        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.addSubview(genresLabel)
        imageView.addSubview(ratingLabel)
    }
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            genresLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            genresLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15)
        ])

        NSLayoutConstraint.activate([
            ratingLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            ratingLabel.leadingAnchor.constraint(equalTo: genresLabel.trailingAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            ratingLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }
}
