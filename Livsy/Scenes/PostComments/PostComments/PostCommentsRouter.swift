//
//  PostCommentsRouter.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentsRoutingLogic {
    func routeToReplies()
    func routeToLogin()
    func dismissSelf()
    func showAlert(with message: String)
}

protocol PostCommentsDataPassing {
    var dataStore: PostCommentsDataStore? { get }
}

final class PostCommentsRouter: PostCommentsRoutingLogic, PostCommentsDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostCommentsViewController?
    var dataStore: PostCommentsDataStore?
    
    func routeToReplies() {
        let destinationVC = PostCommentRepliesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToReplies(source: dataStore!, destination: &destinationDS)
        navigateToReplies(source: viewController!, destination: destinationVC)
    }
    
    func navigateToReplies(source: PostCommentsViewController, destination: PostCommentRepliesViewController) {
        let navController = UINavigationController(rootViewController: destination)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .coverVertical
        viewController?.present(navController, animated: true, completion: nil)
    }
    
    func passDataToReplies(source: PostCommentsDataStore, destination: inout PostCommentRepliesDataStore) {
        destination.replies = source.commentAndReplies
        destination.postID = source.postID
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func navigateToLogin(source: PostCommentsViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func dismissSelf() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message, message: nil, buttonTitle: "OK", buttonAction: nil)
    }
    
}
