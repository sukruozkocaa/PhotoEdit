//
//  ColorCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 9.12.2022.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 15
    }
    
    func configure(color: UIColor) {
        colorView.backgroundColor = color
    }
}
