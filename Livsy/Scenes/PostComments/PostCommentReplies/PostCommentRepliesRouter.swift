//
//  PostCommentRepliesRouter.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentRepliesRoutingLogic {
    func routeToLogin()
    func dismissSelf()
    func showAlert(with message: String)
}

protocol PostCommentRepliesDataPassing {
    var dataStore: PostCommentRepliesDataStore? { get }
}

final class PostCommentRepliesRouter: PostCommentRepliesRoutingLogic, PostCommentRepliesDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostCommentRepliesViewController?
    var dataStore: PostCommentRepliesDataStore?
    
    func routeToLogin() {
       // viewController?.tabBarController?.selectedIndex = 1
        
        let destinationVC = LoginViewController()
        var destinationDS = destinationVC.router!.dataStore!
        navigateToLogin(source: viewController!, destination: destinationVC)
        passDataToLoginScene(source: dataStore!, destination: &destinationDS)
    }
    
    func navigateToLogin(source: PostCommentRepliesViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToLoginScene(source: PostCommentRepliesDataStore, destination: inout LoginDataStore) {
        destination.dismissMode = .toComments
    }
    
    func dismissSelf() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message, message: nil, buttonTitle: "OK", buttonAction: nil)
    }
    
}
