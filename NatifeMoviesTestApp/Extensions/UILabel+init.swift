//
//  UILabel+init.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 22.06.2024.
//

import UIKit

extension UILabel {
    convenience init(font: UIFont?, alighment: NSTextAlignment = .left) {
        self.init()
        self.font = font
        self.textAlignment = alighment
        self.textColor = .white
        self.backgroundColor = .clear
        self.adjustsFontSizeToFitWidth = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
