//
//  MaintabBarController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .postText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let postListVC = PostListViewController()
        let postListNC = UINavigationController(rootViewController: postListVC)
        let postListImage = UIImage(systemName: "play")
        let postListImageSelected = UIImage(systemName: "play.fill")
        let postListItem = UITabBarItem(title: postListVC.title, image: postListImage, selectedImage: postListImageSelected)
        postListVC.tabBarItem = postListItem
        
        let profileVC = ProfileViewController()
        let profileNC = UINavigationController(rootViewController: profileVC)
        let profileImage = UIImage(systemName: "person")
        let profileImageSelected = UIImage(systemName: "person.fill")
        let profileItem = UITabBarItem(title: "Profile", image: profileImage, selectedImage: profileImageSelected)
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
    
}
