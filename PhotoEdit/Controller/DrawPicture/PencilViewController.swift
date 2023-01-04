//
//  PencilsViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 22.12.2022.
//

import UIKit
import AVFoundation

protocol sendDrawImageProtocol {
    func sendImage(image: UIImage)
}

public enum CollectionEditCells: Int {
    case thicknessCell
    case colorCell
    static var count: Int { return CollectionEditCells.colorCell.rawValue + 1}
}

class PencilViewController: UIViewController {

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: Constants.shared.screenSize.height*Constants.shared.getImageCollectionViewCellSize()+120, width: Constants.shared.screenWidth(), height: Constants.shared.collectionViewHeightSize()),collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let saveImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "save")
        image.layer.cornerRadius = 15
        return image
    }()
    
    fileprivate weak var drawnImageView: UIImageView?
    fileprivate weak var savedImageView: UIImageView?
    
    var image: UIImage?
    var backupImage: UIImage?
    var delegate: sendDrawImageProtocol?
    var drawImageView: DrawnImageView?
    let size: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.backgroundColor = Constants.shared.backgroundColor
        addGesture()
        drawImageView?.frame = AVMakeRect(aspectRatio: (drawImageView?.image!.size)!, insideRect: drawImageView!.bounds)
        drawConfigure()
        collectionViewRegisters()
        savedConfigure()
        
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(undoImage))
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(savedImage))
        navigationItem.rightBarButtonItems = [saveButton, undoButton]
    }
    
    @objc func undoImage() {
        self.image = drawImageView?.screenShot
        drawConfigure()
        drawImageView?.image = backupImage
    }
    
    @objc func savedImage() {
        delegate?.sendImage(image: (drawnImageView?.screenShot!)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionViewRegisters() {
        collectionView.register(UINib(nibName: Constants.shared.lineThicknessCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.lineThicknessCell)
        collectionView.register(UINib(nibName: Constants.shared.lineColorCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.lineColorCell)
        collectionView.backgroundColor = Constants.shared.backgroundColor
    }
    
    private func addGesture() {
        drawImageView?.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        drawImageView?.addGestureRecognizer(pinchGesture)
    }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            drawImageView?.frame = CGRect(x: 0, y: 0, width: size*scale, height: size*scale)
            drawImageView?.center = view.center
        }
    }
    
    func drawConfigure() {
        drawImageView = addImageView(image:self.image) as DrawnImageView
        drawImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawImageView!.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        drawImageView!.heightAnchor.constraint(equalToConstant: 370).isActive = true
        drawImageView!.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.1).isActive = true
        self.drawnImageView = drawImageView
    }
    
    func savedConfigure() {
        let savedImageView = addImageView()
        savedImageView.topAnchor.constraint(equalTo: savedImageView.bottomAnchor, constant: 60).isActive = true
        savedImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.savedImageView = savedImageView
    }
    
    private func addImageView<T: UIImageView>(image: UIImage? = nil) -> T {
        let imageView = T(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return imageView
    }
}

extension PencilViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionEditCells = CollectionEditCells.init(rawValue: indexPath.row)!
        switch cell {
            
        case .thicknessCell:
            let cell: LineThicknessCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.lineThicknessCell, for: indexPath) as! LineThicknessCell
            cell.delegate = self
            return cell
        case .colorCell:
            let cell: LineColorCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.lineColorCell, for: indexPath) as! LineColorCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell: CollectionEditCells = CollectionEditCells.init(rawValue: indexPath.row)!
        switch cell {
        case .thicknessCell:
            return CGSize(width: view.frame.width, height: 20)

        case .colorCell:
            return CGSize(width: view.frame.width-50, height: 50)
        }
    }
}

extension PencilViewController: selectedColorProtocol, selectedLineThicknessProtocol{
    func sendThickness(thickness: Double) {
        drawImageView?.setupLine(thickness:thickness)
    }
    
    func sendColor(color: UIColor) {
        self.image = drawImageView?.screenShot
        drawConfigure()
        drawImageView?.setupView(color: color)
    }
}
