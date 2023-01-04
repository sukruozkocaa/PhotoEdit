//
//  ImageCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 1.12.2022.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
