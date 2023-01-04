//
//  HelloViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 19.12.2022.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "deneme")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let selectView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let selectLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select And Fix"
        label.textColor = .white
        label.font = UIFont(name: "Verdana-Bold", size: Constants.shared.getStartedLabelSize())
        return label
    }()
    
    private let nextButton: UIButton = {
       let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 20)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        return button
    }()
    
    private let serviceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        let stringOne = "By connecting, I accept  Term of Service"
        let stringTwo = "Term of Service"
        let range = (stringOne as NSString).range(of: stringTwo)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: range)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: Constants.shared.getServiceLabelFontSize()), range: range)
        label.attributedText = attributedText
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(termService))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private var animationView: LottieAnimationView = {
       let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("map")
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private var buttonAnimationView: LottieAnimationView = {
       let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.animation = LottieAnimation.named("swipe2")
        animationView.loopMode = .loop
        animationView.play()
        animationView.isUserInteractionEnabled = true
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.shared.backgroundColor
        //view.addSubview(imageView)
        //view.addSubview(nextButton)
        view.addSubview(selectView)
        view.addSubview(serviceLabel)
        selectView.addSubview(selectLabel)
        view.addSubview(animationView)
        view.addSubview(buttonAnimationView)
        imageAddConstraint()
        selectViewConstraint()
        selectViewLabelConstraint()
        nextAnimationConstraints()
        termServiceLabelConstraint()
    }
    
    @objc func termService() {
        print("Service Clicked")
    }
    
    @objc func goToHome(sender: UITapGestureRecognizer?) {
        //let vc = HomesViewController()
        print("Çalışmıyor")
        let vc = HomePageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imageAddConstraint() {
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.1),
            animationView.heightAnchor.constraint(equalToConstant: view.frame.height*0.55),
            animationView.widthAnchor.constraint(equalToConstant: view.frame.width*0.8)
        ])
    }
    
    func selectViewConstraint() {
        NSLayoutConstraint.activate([
            selectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectView.topAnchor.constraint(equalTo: view.topAnchor ,constant:view.frame.height*0.75),
            selectView.widthAnchor.constraint(equalToConstant: view.frame.width-20),
            selectView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func selectViewLabelConstraint() {
        NSLayoutConstraint.activate([
            selectLabel.centerXAnchor.constraint(equalTo: selectView.centerXAnchor)
        ])
    }

    func nextAnimationConstraints() {
        NSLayoutConstraint.activate([
            buttonAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonAnimationView.widthAnchor.constraint(equalToConstant: view.frame.size.width*0.9),
            buttonAnimationView.heightAnchor.constraint(equalToConstant: 100),
            buttonAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -view.frame.height*0.08)
        ])
    }
    
    func termServiceLabelConstraint() {
        NSLayoutConstraint.activate([
            serviceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height*0.05),
            serviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
