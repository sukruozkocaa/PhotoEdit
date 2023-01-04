//
//  ImagesCollectionViewCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 1.12.2022.
//

import UIKit

protocol goToEditVCProtocol {
    func goToEdit(vcIndex: Int, indexPath: IndexPath)
}

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    var viewModel = ImageViewModel.shared
    var service = PhotoService.shared
    var delegate: goToEditVCProtocol?
    
    private let collectionView: UICollectionView = {
        let layout = ImagesCollectionViewCell.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UINib(nibName: Constants.shared.imageCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.imageCell)
        return cv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.backgroundColor = .clear
        collectionView.frame = mainView.frame
        collectionView.dataSource = self
        collectionView.delegate = self
        mainView.addSubview(collectionView)
    }
    
    func configure() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = mainView.bounds
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)), subitem: verticalStackItem, count: 2)
        
        let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripletHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3)), subitem: tripletItem, count: 3)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7)), subitems: [item,verticalStackGroup,])
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [horizontalGroup,tripletHorizontalGroup])
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return UICollectionViewCompositionalLayout (section: section)
    }
}

extension ImagesCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.imageCell, for: indexPath) as! ImageCell
        cell.configure(image: viewModel.photos[indexPath.row].photo)
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.shared.getImagesCellSize(), height: Constants.shared.getImagesCellSize()+20)
    } */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.selectedHeaderIndex == 0 {
            viewModel.filterImageArray = []
            viewModel.selectedImage = viewModel.photos[indexPath.row].photo
            for i in 0...viewModel.filterArray.count-1 {
                if viewModel.filterArray[i] == "original" {
                    viewModel.filterImageArray.append(viewModel.selectedImage!)
                }else {
                    viewModel.filterImageArray.append(service.applyFilter(image: viewModel.selectedImage!, filterEffect: viewModel.filterArray[i]))
                }
            }
            delegate?.goToEdit(vcIndex: 0, indexPath: indexPath)
        }
        else if viewModel.selectedHeaderIndex == 1 {
            delegate?.goToEdit(vcIndex: 1,indexPath: indexPath)
        }
    }
}
