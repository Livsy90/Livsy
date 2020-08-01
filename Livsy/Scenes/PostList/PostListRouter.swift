//
//  PostListRouter.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostListRoutingLogic {
    func routeToPost(with postID: Int)
    func routeToLogin()
}

protocol PostListDataPassing {
    var dataStore: PostListDataStore? { get }
}

final class PostListRouter: PostListRoutingLogic, PostListDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostListViewController?
    var dataStore: PostListDataStore?
    
    func routeToPost(with postID: Int) {
        let destinationVC = PostViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToCustomerSummary(postID: postID, source: dataStore!, destination: &destinationDS)
        navigateToCustomerSummary(source: viewController!, destination: destinationVC)
    }
    
    func navigateToCustomerSummary(source: PostListViewController, destination: PostViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToCustomerSummary(postID: Int, source: PostListDataStore, destination: inout PostDataStore) {
        destination.id = postID
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func navigateToLogin(source: PostListViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
}
