//
//  SmallImagesCollectionCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 13.12.2022.
//

import UIKit

protocol scrollToBigImageProtocol {
    func scrollToImage(image: UIImage)
}

class SmallImagesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ImageViewModel.shared
    var delegate: scrollToBigImageProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: Constants.shared.smallImagesCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.smallImagesCell)
    }
    
    func configure(indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension SmallImagesCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.finishEditImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SmallImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.smallImagesCell, for: indexPath) as! SmallImagesCell
        cell.configure(image: viewModel.finishEditImageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.shared.getImagesCellSize(), height: Constants.shared.getImagesCellSize()+20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        delegate?.scrollToImage(image: viewModel.finishEditImageArray[indexPath.row])
    }
}
