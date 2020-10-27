//
//  PostRouter.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostRoutingLogic {
    func routeToPostComments()
}

protocol PostDataPassing {
    var dataStore: PostDataStore? { get }
}

final class PostRouter: PostRoutingLogic, PostDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostViewController?
    var dataStore: PostDataStore?
    
    func routeToPostComments() {
        let destinationVC = PostCommentsViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPostComments(source: dataStore!, destination: &destinationDS)
        navigateToPostComments(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPostComments(source: PostViewController, destination: PostCommentsViewController) {
        let navController = UINavigationController(rootViewController: destination)
        navController.modalPresentationStyle = .automatic
        navController.modalTransitionStyle = .coverVertical
        viewController?.present(navController, animated: true, completion: nil)
    }
    
    func passDataToPostComments(source: PostDataStore, destination: inout PostCommentsDataStore) {
        destination.commentsData = source.comments
        destination.postID = source.id
    }
}
