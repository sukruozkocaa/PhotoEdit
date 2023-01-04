//
//  OpenAIViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 22.12.2022.
//

import UIKit
import Lottie

class OpenAIViewController: UIViewController {

    private let imageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.layer.cornerRadius = 15
        image.isHidden = true
        return image
    }()
    
    private var animationView: LottieAnimationView = {
       let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("gallery")
        animationView.loopMode = .repeat(2)
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let createButton: UIButton = {
       let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 15)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createImageClicked), for: .touchDown)
        return button
    }()
    
    private let createTextField: UITextField = {
       let text = UITextField()
        text.font = UIFont(name: "GillSans-Bold", size: Constants.shared.getHomeTextFieldItemSize())
        text.textAlignment = .center
        text.tintColor = .orange
        text.backgroundColor = .white
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.orange.cgColor
        text.placeholder = "Please created image names"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let largeFont = UIFont.systemFont(ofSize: 40)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "square.and.arrow.down",withConfiguration: configuration), for: .normal)
        button.isHidden = true
        button.tintColor = .black
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(downloadImage), for: .touchDown)
        return button
    }()

    let createViewModel = CreateImageViewModel()
    var viewModel = ImageViewModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        imageView.image = UIImage(named: "bina")
        view.addSubview(imageView)
        view.addSubview(animationView)
        
        view.addSubview(createTextField)
        view.addSubview(createButton)
        view.addSubview(downloadButton)
        imageViewConstraints()
        animationViewConstraint()
        textFieldConstraints()
        createButtonconstraints()
        downloadButtonConstraints()
    }
    
    @objc func createImageClicked() {
        animationView.isHidden = false
        imageView.isHidden = true
        downloadButton.isHidden = true
        if createTextField.text == "" {
            createTextField.placeholder = "Please enter value!"
        }
        else {
            animationView.animation = LottieAnimation.named("create")
            animationView.play()
            createButton.backgroundColor = .gray
            createButton.isEnabled = false
            
            Task {
                let result = await createViewModel.generateImage(prompt: createTextField.text!)
                if result == nil {
                    print("NİL")
                }
                self.animationView.isHidden = true
                self.imageView.isHidden = false
                self.imageView.image = result
                downloadButton.isHidden = false
                createButton.backgroundColor = .black
                createButton.isEnabled = true
            }
        }
    }
    
    @objc func downloadImage() {
        let alert = UIAlertController(title: "Save Image?", message: "Save image as Local? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [self] action in
            let imageData = self.imageView.image!.pngData()! as Data
            let compressedImage = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            imageView.isHidden = true
            animationView.isHidden = false
            animationView.animation = LottieAnimation.named("gallery")
            animationView.play()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in}))
        self.present(alert, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        createViewModel.setup()
    }
    
    func imageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.1),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func animationViewConstraint() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.1),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            animationView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func textFieldConstraints() {
        NSLayoutConstraint.activate([
            createTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant:20),
            createTextField.widthAnchor.constraint(equalToConstant: view.frame.width*0.8)
        ])
    }
    
    func createButtonconstraints() {
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.8),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: Constants.shared.getHomeCameraItemSize()),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func downloadButtonConstraints() {
        NSLayoutConstraint.activate( [
            downloadButton.leftAnchor.constraint(equalTo: createButton.rightAnchor,constant:10),
            downloadButton.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.8)
        ])
    }
}
