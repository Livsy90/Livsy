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
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        viewController?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController?.navigationController?.pushViewController(destination, animated: false)
    }
    
    func passDataToReplies(source: PostCommentsDataStore, destination: inout PostCommentRepliesDataStore) {
        destination.replies = source.commentAndReplies
        destination.postID = source.postID
        destination.parentComment = source.parentComment
        destination.authorName = source.authorName
        destination.image = source.image
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        var destinationDS = destinationVC.router!.dataStore!
        navigateToLogin(source: viewController!, destination: destinationVC)
        passDataToLoginScene(source: dataStore!, destination: &destinationDS)
    }
    
    func navigateToLogin(source: PostCommentsViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToLoginScene(source: PostCommentsDataStore, destination: inout LoginDataStore) {
        destination.dismissMode = .toComments
    }
    
    func dismissSelf() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromBottom
        viewController?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController?.navigationController?.popViewController(animated: false)
    }
    
    func showAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message, message: nil, buttonTitle: Text.Common.ok, buttonAction: nil)
    }
    
}
