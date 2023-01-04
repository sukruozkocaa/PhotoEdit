//
//  Constants.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 8.12.2022.
//

import Foundation
import UIKit

class Constants {
    static let shared = Constants()
    
    //MARK: Views BackgroundColor
    let backgroundColor = UIColor(cgColor: CGColor(red: 27/255, green: 26/255, blue: 33/255, alpha: 1))
    
    //MARK: StoryBoard Name
    let storyboardName = "Main"
        
    //MARK: HomeViewController - Attributes
    let homeTitle = "Album"
    let homeViewController = "HomeViewController"
    let editViewController = "EditViewController"
    let albumCollectionCell = "AlbumCollectionViewCell"
    let headerCollectionCell = "HeaderCollectionViewCell"
    let imagesCollectionCell = "ImagesCollectionViewCell"
    
    //MARK: HomeViewController - CollectionView Cells
    let imageCell = "ImageCell"
    let headerCell = "HeaderCell"
    let albumCell = "AlbumCell"
    
    //MARK: EditViewController - Attributes
    let editTitle = "Edit"
    let editImagesCollectionCell = "ImagesCollectionCell"
    let editFilterCollectionCell = "FilterCollectionCell"
    let editBrightnessCollectionCell = "BrightnessCollectionCell"
    let editItemsCollectionCell = "ItemsCollectionCell"
    
    //MARK: EditViewController - CollectionView Cells
    let editImagesCell = "ImagesCell"
    let editFilterCell = "FilterCell"
    let editBrightCell = "BrightnessCell"
    let editItemsCell = "ItemsCell"
    
    //MARK: PencilViewController
    let lineThicknessCell = "LineThicknessCell"
    let lineColorCell = "LineColorCell"
    let colorCell = "ColorCell"

    //MARK: GalleryViewController
    let smallImagesCollectionCell = "SmallImagesCollectionCell"
    let smallImagesCell = "SmallImagesCell"
    
    let screenSize: CGRect = UIScreen.main.bounds

    func getServiceLabelFontSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 17
        }
        else {
            return 15
        }
    }
    
    func getStartedLabelSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 30
        }
        else {
            return 22
        }
    }
    
    func getAlbumCellSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 260
        }
        else {
            return 250
        }
    }
    
    func getImagesCellSize() -> CGFloat {
        if screenSize.width >= 390 && screenSize.width<=428 {
            return 120
        }
        else if screenSize.width >= 429 {
            return 135
        }
        else {
            return 115
        }
    }
    
    func getHeaderCellSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 80
        }
        else {
            return 60
        }
    }
    
    func screenWidth() -> CGFloat {
        return screenSize.width
    }
    
    func collectionViewHeightSize() -> CGFloat {
        return 300
    }
    
    func editItemSize() -> CGFloat {
        if screenSize.width >= 390 && screenSize.width <= 428 {
            return 53
        }
        else if screenSize.width >= 429 {
            return 60
        }
        else {
            return 50
        }
    }
    
    func getHomeCameraItemSize() -> CGFloat {
        if screenSize.width >= 393  {
            return 120
        }
        else {
            return 90
        }
    }
    
    func getHomeCameraOpenItemSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 250
        }
        else {
            return 180
        }
    }
    
    func getHomeTextFieldItemSize() -> CGFloat {
        if screenSize.width >= 393 {
            return 20
        }
        else {
            return 16
        }
    }
    
    func getImageCollectionViewCellSize() -> CGFloat {
        if screenSize.width >= 390 {
            return 0.7
        }
        else {
            return 0.66
        }
    }
    
    func getEditImageViewSize() -> CGFloat {
        if screenSize.width >= 390 {
            return 0.2
        }else {
            return 0.2
        }
    }
}
