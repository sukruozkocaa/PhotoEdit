//
//  FilterCollectionCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 6.12.2022.
//

import UIKit

protocol selectedfilterImage {
    func selectedFilter(image: UIImage)
    func reload()
}

class FilterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ImageViewModel.shared
    var delegate: selectedfilterImage?
    var service = PhotoService.shared
    
    var selectedImage: UIImage?
    var filterArray = [String]()
    
    var width: Double?
    var height: Double?
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedImage = viewModel.selectedImage!
        filterArray = viewModel.filterArray
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        collectionView.register(UINib(nibName: Constants.shared.editFilterCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editFilterCell)
    }
}

extension FilterCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editFilterCell, for: indexPath) as! FilterCell
        cell.delegate = self
        cell.configure(image: self.viewModel.filterImageArray[indexPath.row],indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedFilter(image: viewModel.filterImageArray.count == 0 ? viewModel.selectedImage! : viewModel.filterImageArray[indexPath.row])
        service.brightnessImage(image: viewModel.filterImageArray[indexPath.row])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
                return CGSize(width: 90, height: 100)
            default:
                return CGSize(width: 80, height: 90)
        }
    }
}

extension FilterCollectionCell: refreshCollectionView {
    func refresh() {
        collectionView.isHidden = false
        DispatchQueue.main.async {
            self.delegate?.reload()
        }
    }
}

