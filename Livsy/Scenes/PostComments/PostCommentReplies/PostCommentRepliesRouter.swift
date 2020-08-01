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
}

protocol PostCommentRepliesDataPassing {
    var dataStore: PostCommentRepliesDataStore? { get }
}

final class PostCommentRepliesRouter: PostCommentRepliesRoutingLogic, PostCommentRepliesDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostCommentRepliesViewController?
    var dataStore: PostCommentRepliesDataStore?
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func navigateToLogin(source: PostCommentRepliesViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func dismissSelf() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
