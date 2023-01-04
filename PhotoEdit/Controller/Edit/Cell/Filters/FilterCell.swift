//
//  FilterCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit

protocol refreshCollectionView {
    func refresh()
}

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var service = PhotoService.shared
    var viewModel = ImageViewModel.shared
    var delegate: refreshCollectionView?
    var indexPath: IndexPath?
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
            imageView.layer.borderWidth = 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = .none
    }
    
    func configure(image: UIImage?, indexPath: IndexPath) {
        self.indexPath = indexPath
        if image == nil {
            imageView.image = viewModel.selectedImage!
        }
        else {
            imageView.image = image
        }
    }
}
