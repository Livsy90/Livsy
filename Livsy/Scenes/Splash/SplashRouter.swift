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
        let destinationVC = PostListViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPostList(source: dataStore!, destination: &destinationDS)
        navigateToPostList(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPostList(source: SplashViewController, destination: PostListViewController) {
        let navController = UINavigationController(rootViewController: destination)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        viewController?.present(navController, animated: true, completion: nil)
    }
    
    func passDataToPostList(source: SplashDataStore, destination: inout PostListDataStore) {
      
    }
}
