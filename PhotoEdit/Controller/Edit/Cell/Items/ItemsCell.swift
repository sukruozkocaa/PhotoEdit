//
//  ItemsCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit


class ItemsCell: UICollectionViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    override var isSelected: Bool {
        didSet {
            imageView.backgroundColor = isSelected ? .orange : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 15
    }

    func configure(item: UIImage) {
        bgImageView.image = item
    }
}

