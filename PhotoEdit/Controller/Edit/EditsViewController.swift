//
//  EditsViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 20.12.2022.
//

import UIKit

private enum CollectionCells: Int {
    case filters
    case brightness
    case item
    static var count: Int { return CollectionCells.item.rawValue + 1}
}

class EditsViewController: UIViewController,CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let editImageView: UIImageView = {
      let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "deneme")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let col = UICollectionView(frame: CGRect(x: 0, y: Constants.shared.screenSize.height - Constants.shared.getAlbumCellSize()+30, width: Constants.shared.screenWidth(), height: Constants.shared.collectionViewHeightSize()),collectionViewLayout: layout)
        col.backgroundColor = .clear
        return col
    }()
    
    var viewModel = ImageViewModel.shared
    var service = PhotoService.shared
    var isFilter: Bool?
    var isBrightness: Bool?
    var isImage: Bool?
    var image = UIImage()
    var backupImage = UIImage()
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.shared.backgroundColor
        view.addSubview(editImageView)
        view.addSubview(collectionView)
        
        self.image = viewModel.selectedImage!
        self.backupImage = viewModel.filterImageArray[0]
        
        editImageView.image = self.image
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(imageTapped))
        let undoTapped = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(undoTapped))
        navigationItem.rightBarButtonItems = [downloadButton, undoTapped]
        register()
    }
    
    func register() {
        collectionView.register(UINib(nibName: Constants.shared.editFilterCollectionCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editFilterCollectionCell)
        collectionView.register(UINib(nibName: Constants.shared.editBrightnessCollectionCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editBrightnessCollectionCell)
        collectionView.register(UINib(nibName: Constants.shared.editItemsCollectionCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.editItemsCollectionCell)
        imageConstraint()
    }
    
    @objc func imageTapped() {
        let alert = UIAlertController(title: "Save Photo", message: "Save photo to Gallery?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            let imageData = self.image.pngData()! as Data
            let compressedImage = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in}))
        self.present(alert, animated: true)
    }
    
    @objc func undoTapped() {
        let alert = UIAlertController(title: "Undo", message: "Do you confirm revert to default? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [self] action in
            self.image = self.backupImage
            applyFilter(image: backupImage, isEdit: false)
            service.brightnessImage(image: backupImage)
            editImageView.image = backupImage
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in}))
        self.present(alert, animated: true)
    }
    
    func imageConstraint() {
        NSLayoutConstraint.activate([
            editImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            editImageView.heightAnchor.constraint(equalTo: editImageView.widthAnchor, multiplier: 1),
            editImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*Constants.shared.getEditImageViewSize())
        ])
        print("abc",Constants.shared.screenSize.width)
    }
    
    func collectionViewConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: editImageView.bottomAnchor)
        ])
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        cropViewController.dismiss(animated: true, completion: nil)
        self.image = image
        applyFilter(image: image, isEdit: true)
        editImageView.image = image
    }
}

extension EditsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionCells = CollectionCells.init(rawValue: indexPath.row)!
        switch cell {
        case .filters:
            let cell: FilterCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editFilterCollectionCell, for: indexPath) as! FilterCollectionCell
            cell.delegate = self
            cell.collectionView.isHidden = isFilter ?? false
            return cell
        case .brightness:
            let cell: BrightnessCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editBrightnessCollectionCell, for: indexPath) as! BrightnessCollectionCell
            cell.collectionView.isHidden = isBrightness ?? true
            cell.delegate = self
            return cell
        case .item:
            let cell: ItemsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.editItemsCollectionCell, for: indexPath) as! ItemsCollectionCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell: CollectionCells = CollectionCells.init(rawValue: indexPath.row)!
        switch cell {
        case .filters:
            return CGSize(width: view.frame.width, height: 100)
        case .brightness:
            return CGSize(width: view.frame.width, height: 30)
        case .item:
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func applyFilter(image: UIImage, isEdit:Bool) {
        viewModel.filterImageArray = []
        viewModel.selectedImage = image
        for i in 0...viewModel.filterArray.count-1 {
            if viewModel.filterArray[i] == "original" {
                if isEdit == true{
                    viewModel.filterImageArray.append(viewModel.selectedImage!)
                }
                else {
                    viewModel.filterImageArray.append(backupImage)
                }
            }
            else {
                viewModel.filterImageArray.append(service.applyFilter(image: viewModel.selectedImage!, filterEffect: viewModel.filterArray[i]))
            }
        }
    }
}

extension EditsViewController: selectedfilterImage, sendCutFinisImagePtorocol, sendItemsIndexProtocol {
    func reload() {
        self.collectionView.reloadData()
    }
    
    func selectedFilter(image: UIImage) {
        self.image = image
        editImageView.image = image
    }
    
    func sendCuttingImage(image: UIImage) {
        self.image = image
        applyFilter(image: image, isEdit: true)
        editImageView.image = image
    }
    
    func sendIndex(index: Int) {
        let items: EditItems = EditItems.init(rawValue: index)!
        switch items {
        case .filter:
            self.title = "Filter"
            self.isFilter = false
            self.isBrightness = true
            self.isImage = false
            collectionView.reloadData()
        case .crop:
            self.title = "Crop"
            self.isFilter = true
            self.isBrightness = true
            self.isImage = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let cropController = CropViewController(croppingStyle: self.croppingStyle, image: self.image)
                cropController.delegate = self
                self.present(cropController, animated: true)
            }
    
        case .brightness:
            self.title = "Brightness"
            self.isImage = false
            self.isBrightness = false
            self.isFilter = true
            service.brightnessImage(image: self.image)

        case .contrast:
            self.title = "Contrast"
            self.isImage = false
            self.isFilter = true
            self.isBrightness = false
            
        case .cut:
            self.title = "Cut"
            self.isImage = false
            self.isBrightness = true
            self.isFilter = true
            let vc = ImageCutsViewController()
            vc.image = self.image
            vc.delegate = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .pencil:
            self.title = "Pencil"
            self.isBrightness = true
            self.isFilter = true
            self.isImage = true
            let vc = PencilViewController()
            vc.image = self.image
            vc.backupImage = self.image
            vc.delegate = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        collectionView.reloadData()
    }
}

extension EditsViewController: applyBrightness, sendDrawImageProtocol{
    func sendImage(image: UIImage) {
        self.image = image
        applyFilter(image: image, isEdit: true)
        self.editImageView.image = image
    }

    func sliderBrightness(image: UIImage) {
        self.image = image
        editImageView.image = image
    }
}
