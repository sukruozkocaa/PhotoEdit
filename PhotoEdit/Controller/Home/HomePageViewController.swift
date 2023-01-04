//
//  HomePageViewController.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 21.12.2022.
//

import UIKit

class HomePageViewController: UIPageViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    lazy var vcList: [UIViewController] = {
        let cameraVC = MenuViewController()
        let homeVC = HomesViewController()
        let welcomeVC = WelcomeViewController()
        return [welcomeVC,homeVC,cameraVC]
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        setInitViews()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setInitViews() {
        self.dataSource = self
        if let vc = vcList.first {
            self.setViewControllers([vc],direction: .reverse, animated: false)
        }
    }
}
extension HomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcList.lastIndex(of: viewController) else { return nil}
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil}
        guard previousIndex < vcList.count else { return nil}
        return vcList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcList.lastIndex(of: viewController) else { return nil}
        let previousIndex = index + 1
        guard previousIndex >= 0 else { return nil}
        guard previousIndex < vcList.count else { return nil}
        return vcList[previousIndex]
    }
}
