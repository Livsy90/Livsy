//
//  MaintabBarController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol TabBarReselectHandling {
    func handleReselect()
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .postText
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let postListVC = PostListViewController()
        let postListNC = NavigationController(rootViewController: postListVC)
        let postListImage = UIImage(systemName: "house")
        let postListImageSelected = UIImage(systemName: "house.fill")
        let postListItem = UITabBarItem(title: Text.Common.livsy, image: postListImage, selectedImage: postListImageSelected)
        postListVC.tabBarItem = postListItem
        
        let profileVC = ProfileViewController()
        let profileNC = NavigationController(rootViewController: profileVC)
        let profileImage = UIImage(systemName: "person")
        let profileImageSelected = UIImage(systemName: "person.fill")
        let profileItem = UITabBarItem(title: Text.Profile.profile, image: profileImage, selectedImage: profileImageSelected)
        profileVC.tabBarItem = profileItem
        
        let controllers = [postListNC, profileNC]
        self.viewControllers = controllers
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard tabBarController.selectedViewController === viewController else { return true }
        guard let navigationController = viewController as? UINavigationController else {
            assertionFailure()
            return true
        }
        
        guard
            navigationController.viewControllers.count <= 1,
            let destinationViewController = navigationController.viewControllers.first as? TabBarReselectHandling
        else {
            return true
        }
        
        destinationViewController.handleReselect()
        return false
    }
    
}
