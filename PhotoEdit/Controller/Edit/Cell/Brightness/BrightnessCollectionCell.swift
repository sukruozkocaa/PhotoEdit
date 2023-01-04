//
//  BrightnessCollectionCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit

class BrightnessCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: applyBrightness?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: Constants.shared.editBrightCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editBrightCell)
    }
}

extension BrightnessCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BrightnessCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editBrightCell, for: indexPath) as! BrightnessCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 30)
    }
}

extension BrightnessCollectionCell: applyBrightness {
    func sliderBrightness(image: UIImage) {
        delegate?.sliderBrightness(image: image)
    }
}
