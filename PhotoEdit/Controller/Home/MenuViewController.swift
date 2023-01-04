//
//  CameraViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 21.12.2022.
//

import UIKit
import Photos

protocol sendIndexRetryProtocol {
    func sendRetry(index:Int)
}

class MenuViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var index:Int?
    var delegate: sendIndexRetryProtocol?
    var viewModel = ImageViewModel.shared
    private let albumButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .white
        let largeFont = UIFont.systemFont(ofSize: Constants.shared.getHomeCameraItemSize())
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.addTarget(self, action: #selector(addGallery), for: .touchDown)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled",withConfiguration: configuration), for: .normal)
        return button
    }()
    
    private let cameraButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        let largeFont = UIFont.systemFont(ofSize: Constants.shared.getHomeCameraItemSize())
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "camera.viewfinder",withConfiguration: configuration), for: .normal)
        button.addTarget(self, action: #selector(addCamera), for: .touchDown)
        return button
    }()
    
    private let createButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeFont = UIFont.systemFont(ofSize: 10)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(named: "openaiii", in: nil,with: configuration), for: .normal)
        button.addTarget(self, action: #selector(createImage), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.shared.backgroundColor
        view.addSubview(albumButton)
        view.addSubview(cameraButton)
        view.addSubview(createButton)
        albumConstraint()
        cameraConstraint()
        createImageConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func albumConstraint() {
        NSLayoutConstraint.activate([
            albumButton.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.625),
            albumButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func cameraConstraint() {
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.41),
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func createImageConstraint() {
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.275),
            createButton.widthAnchor.constraint(equalToConstant: Constants.shared.getHomeCameraOpenItemSize()),
            createButton.heightAnchor.constraint(equalToConstant: Constants.shared.getHeaderCellSize()),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func addCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func addGallery() {
        var imagePickerController = UIImagePickerController()
         imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
         imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: {})
    }
    
    @objc func createImage() {
        let vc = OpenAIViewController()
        self.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageData = image.pngData()! as Data
        let compressedImage = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
