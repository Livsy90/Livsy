//
//  PostListRouter.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostListRoutingLogic {
    func routeToPost(id: Int, url: String)
    func routeToLogin()
    func showSignOutResultAlert()
    func showSignOutQuestionAlert(completion: @escaping (() -> Void))
}

protocol PostListDataPassing {
    var dataStore: PostListDataStore? { get }
}

final class PostListRouter: PostListRoutingLogic, PostListDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostListViewController?
    var dataStore: PostListDataStore?
    
    var imageView = WebImageView()
    
    func routeToPost(id: Int, url: String) {
        let destinationVC = PostViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPost(postID: id, imageURL: url, source: dataStore!, destination: &destinationDS)
        navigateToPost(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPost(source: PostListViewController, destination: PostViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToPost(postID: Int, imageURL: String, source: PostListDataStore, destination: inout PostDataStore) {
        destination.id = postID
        imageView.set(imageURL: imageURL)
        destination.image = imageView.image ?? UIImage()
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func navigateToLogin(source: PostListViewController, destination: LoginViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func showSignOutQuestionAlert(completion: @escaping (() -> Void)) {
        viewController?.showAlertWithTwoButtons(title: "Are you sure?", firstButtonTitle: "Yes", secondButtonTitle: "No", firstButtonAction: completion, secondButtonAction: nil)
    }
    
    func showSignOutResultAlert() {
        viewController?.showNoButtonAlert(title: "You are logged out")
    }
    
}
