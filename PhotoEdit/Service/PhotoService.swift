//
//  Service.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 30.11.2022.
//

import Foundation
import CoreImage
import UIKit

class PhotoService {
    static let shared = PhotoService()
    
    var viewModel = ImageViewModel.shared
    var aCIImage = CIImage()
    var contrastFilter: CIFilter!
    var brightnessFilter: CIFilter!
    var context = CIContext()
    var outputImage = CIImage()
    var newUIImage = UIImage()
    var aUIImage = UIImage()
    var count = 0
    
    func brightnessImage(image: UIImage) {
        self.aUIImage = image
        let aCGImage = aUIImage.cgImage
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil)
        contrastFilter = CIFilter(name: "CIColorControls");
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
    
    func applyBrightness(sender: Float) -> UIImage? {
        brightnessFilter.setValue(NSNumber(value: sender), forKey: "inputBrightness");
        outputImage = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: imageRef!)
        return newUIImage
    }
    
    func applyFilter(image: UIImage, filterEffect: String) -> UIImage {
        let context = CIContext(options: nil)
        var imageF = UIImage()
        if let currentFilter = CIFilter(name: filterEffect) {
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    imageF = UIImage(cgImage: cgimg)
                }
            }
        }
        return imageF
    }
}
