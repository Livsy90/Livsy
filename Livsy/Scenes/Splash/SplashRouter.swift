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
        let navController = UINavigationController(rootViewController: destination)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
}
