//
//  BrightnessCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit

public protocol applyBrightness {
    func sliderBrightness(image: UIImage)
}

class BrightnessCell: UICollectionViewCell {

    @IBOutlet weak var slider: UISlider!
    let service = PhotoService.shared
    
    var delegate: applyBrightness?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func applyBrightness(_ sender: UISlider) {
        let image = service.applyBrightness(sender: sender.value)
        delegate?.sliderBrightness(image: image!)
    }
}
