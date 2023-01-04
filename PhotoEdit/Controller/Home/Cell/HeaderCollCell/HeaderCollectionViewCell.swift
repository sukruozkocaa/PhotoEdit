//
//  HeaderCollectionViewCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 1.12.2022.
//

import UIKit
import Photos

protocol selectedHeaderProtocol {
    func selectedHeaderIndex(index: Int)
}

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: selectedHeaderProtocol?
    var viewModel = ImageViewModel.shared
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.register(UINib(nibName: Constants.shared.headerCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.headerCell)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    func configure() {
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumImported, options: nil)
        print(albumList.count)
    }
}
extension HeaderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menuArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.headerCell, for: indexPath) as! HeaderCell
        cell.configure(with: viewModel.menuArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedHeaderIndex(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.3, height: 50)
    }
}
