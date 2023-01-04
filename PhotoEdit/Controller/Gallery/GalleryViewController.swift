//
//  GalleryViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 20.12.2022.
//

import UIKit

class GalleryViewController: UIViewController {

    private let imageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let col = UICollectionView(frame: CGRect(x: 10, y: Constants.shared.screenSize.height*Constants.shared.getImageCollectionViewCellSize(), width: Constants.shared.screenWidth(), height: Constants.shared.collectionViewHeightSize()),collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.translatesAutoresizingMaskIntoConstraints = false
        col.register(UINib(nibName: Constants.shared.smallImagesCollectionCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.smallImagesCollectionCell)
        return col
    }()
    
    var image: UIImage?
    var viewModel = ImageViewModel()
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = Constants.shared.backgroundColor
        view.addSubview(imageView)
        view.addSubview(collectionView)
        imageViewConstraints()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        let image = UIImage(named: "share")
        let imageToShare = [image!]
        let activityController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.present(activityController, animated: true)
    }
    
    func imageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.1),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height*0.7),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SmallImagesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.smallImagesCollectionCell, for: indexPath) as! SmallImagesCollectionCell
        cell.delegate = self
        cell.configure(indexPath: self.selectedIndexPath!)
        return cell
    }
    
    func collectionView(_ collectioView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

extension GalleryViewController: scrollToBigImageProtocol {
    func scrollToImage(image: UIImage) {
        imageView.image = image
    }
}
