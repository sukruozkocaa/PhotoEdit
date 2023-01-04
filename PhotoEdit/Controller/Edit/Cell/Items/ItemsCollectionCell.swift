//
//  ItemsCollectionCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit

protocol sendItemsIndexProtocol {
    func sendIndex(index: Int)
}

public enum EditItems: Int{
    case filter
    case crop
    case brightness
    case contrast
    case cut
    case pencil
    static var count: Int { return EditItems.pencil.rawValue + 1}
}

class ItemsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ImageViewModel.shared
    var delegate: sendItemsIndexProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: Constants.shared.editItemsCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editItemsCell)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        print("aaa",Constants.shared.screenSize.width)
    }
}

extension ItemsCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterIconArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemsCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editItemsCell, for: indexPath) as! ItemsCell
        cell.configure(item: UIImage(named: viewModel.filterIconArray[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
            return CGSize(width: Constants.shared.editItemSize() + 3, height: 50)
            default:
            print(Constants.shared.editItemSize())
            return CGSize(width: Constants.shared.editItemSize() , height: 43)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendIndex(index: indexPath.row)
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}
