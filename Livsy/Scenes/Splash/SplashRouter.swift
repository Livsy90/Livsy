//
//  SplashRouter.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol SplashRoutingLogic {
    func routeToPostList()
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

final class SplashRouter: SplashRoutingLogic, SplashDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: SplashViewController?
    var dataStore: SplashDataStore?
    
    func routeToPostList() {
        let destinationVC = MainTabBarController()
        navigateToTabBar(source: viewController!, destination: destinationVC)
    }
    
    func navigateToTabBar(source: SplashViewController, destination: MainTabBarController) {
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(destination)
        viewController?.navigationController?.pushViewController(destination, animated: false)
    }
    
}

//
//// SceneDelegate.swift or AppDelegate.swift
//
//func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
//    guard let window = self.window else {
//        return
//    }
//
//    window.rootViewController = vc
//
//    // add animation
//    UIView.transition(with: window,
//                      duration: 0.5,
//                      options: [.transitionFlipFromLeft],
//                      animations: nil,
//                      completion: nil)
//
//}
