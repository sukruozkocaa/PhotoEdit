//
//  HomesViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 20.12.2022.
//

import UIKit
import Photos

private enum Cells: Int {
    case header
    case images
    static var count: Int { return Cells.images.rawValue + 1}
}

class HomesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: Constants.shared.screenSize.width, height: Constants.shared.screenSize.height), collectionViewLayout: layout)
        collectionView.collectionViewLayout = flowLayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        collectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        collectionView.insetsLayoutMarginsFromSafeArea = true
        return collectionView
    }()
    
    var viewModel = ImageViewModel.shared
    let service = PhotoService.shared
    var imageArray: [UIImage]?
    var isReload: Bool? = false
    var scrollSize: Double?
    var imagePicker = UIImagePickerController()
    
    private var photos = [Photo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.backgroundColor = Constants.shared.backgroundColor
        title = Constants.shared.homeTitle
        
        let indexPath = collectionView.indexPathsForSelectedItems?.last ?? IndexPath(item: 1, section: 0)
     //   collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.viewModel.photos.removeAll()
            self.requestAuthorizationAndFetchPhotos()
            self.collectionView.reloadData()
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    func fetchPhotos() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat  //KALİTE AYARLARI KONTROL PLS. :)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 200), contentMode: .aspectFit, options: requestOptions) { image, _ in
                    if let image = image {
                        let photo = Photo(id: UUID(), photo: image)
                        self.viewModel.photos.append(photo)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
        }
    }
    
    func requestAuthorizationAndFetchPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.fetchPhotos()
            default:
                break
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        save(image: image)
        self.isReload = true
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        imagePicker.dismiss(animated: true)
    }
    
    func save(image: UIImage) {
        let imageData = image.pngData()! as Data
        let compressedImage = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
    }
}

extension HomesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cells = Cells.init(rawValue: indexPath.row)!
        switch cell {
        case .header:
            let cell: HeaderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
            cell.configure()
            return cell
        case .images:
            let cell: ImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell: Cells = Cells.init(rawValue: indexPath.row)!
        switch cell {
        case .header:
            return CGSize(width: view.frame.width, height: view.frame.height*0.1)
        case .images:
            return CGSize(width: view.frame.width, height: view.frame.height*0.8)
        }
    }
}


/*
extension HomesViewController: sendVCProtocol {
     func sendVC(vc: UIViewController) {
         self.navigationController?.pushViewController(vc, animated: true)
     }
 } */

extension HomesViewController: goToEditVCProtocol {
    func goToEdit(vcIndex: Int, indexPath: IndexPath) {
        if vcIndex == 0 {
            let vc = EditsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if vcIndex == 1 {
            let vc = GalleryViewController()
            vc.image = viewModel.photos[indexPath.row].photo
            vc.selectedIndexPath = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
 
