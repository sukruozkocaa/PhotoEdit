//
//  ImageViewModel.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 28.11.2022.
//

import Foundation
import UIKit
import OpenAL
import OpenAIKit

class ImageViewModel {
    
    static let shared = ImageViewModel()
    var selectedImage: UIImage?
    var selectedCutImage: UIImage?
    var selectedHeaderIndex: Int? = 0
    
    var photos = [Photo]()
    var filterImageArray = [UIImage]()
    var finishEditImageArray = [UIImage]()
    
    var pencilColorArray = [UIColor.black, UIColor.white, UIColor.gray, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.orange, UIColor.green, UIColor.brown, UIColor.cyan, UIColor.purple]
    var filterArray = ["original","CISepiaTone", "CIPhotoEffectProcess", "CIGaussianBlur", "CIPhotoEffectNoir","CISpotLight","CIComicEffect","CICrystallize","CIXRay","CIThermal","CIPointillize","CISpotColor"]
    
    var menuArray = ["All photo", "Favorites", "Edited"]
    var filterIconArray = ["filter","crop","bright","contrast","nodes","pen"]
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}

