//
//  ImageCutsViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 22.12.2022.
//

import UIKit

protocol sendCutFinisImagePtorocol {
    func sendCuttingImage(image: UIImage)
}

class ImageCutsViewController: UIViewController, ImageFreeCutViewDelegate{
    
    private let viewCut: ImageFreeCutView = {
       let view = ImageFreeCutView()
        view.backgroundColor = Constants.shared.backgroundColor
        view.imageView.contentMode = .scaleAspectFit
        view.imageCutShapeLayer.strokeColor = UIColor.green.cgColor
        view.imageCutShapeLayer.lineWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var delegate: sendCutFinisImagePtorocol?
    var image: UIImage?
    override func viewDidLoad() {
        viewCut.imageToCut = image
        super.viewDidLoad()
        view.addSubview(viewCut)
        viewCutConstraints()
        viewCut.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func imageFreeCutView(_ imageFreeCutView: ImageFreeCutView, didCut image: UIImage?) {
        delegate?.sendCuttingImage(image: image!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewCutConstraints() {
        NSLayoutConstraint.activate([
            viewCut.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            viewCut.widthAnchor.constraint(equalToConstant: view.frame.width),
            viewCut.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }
}
