//
//  LineColorCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 9.12.2022.
//

import UIKit

protocol selectedColorProtocol {
    func sendColor(color: UIColor)
}

class LineColorCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ImageViewModel.shared
    var delegate: selectedColorProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: Constants.shared.colorCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.colorCell)
    }
}

extension LineColorCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pencilColorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ColorCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.colorCell, for: indexPath) as! ColorCell
        cell.configure(color: viewModel.pencilColorArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendColor(color: viewModel.pencilColorArray[indexPath.row])
    }
}
