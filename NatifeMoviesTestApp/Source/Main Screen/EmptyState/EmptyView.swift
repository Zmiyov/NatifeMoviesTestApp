//
//  EmptyView.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 24.06.2024.
//

import UIKit

final class EmptyView: UIView {
    let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "noData")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor)
        ])
    }
}
