//
//  UIImage+ActivityIndicator.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 25.06.2024.
//

import UIKit
import Kingfisher

extension UIImageView{
   func loadImage(_ url : URL?) {
       self.kf.indicatorType = .activity
       self.kf.setImage(with: url)
   }

}
