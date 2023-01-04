//
//  SmallImagesCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 13.12.2022.
//

import UIKit

class SmallImagesCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
            imageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 15
    }

    func configure(image: UIImage) {
        imageView.image = image
    }
}
