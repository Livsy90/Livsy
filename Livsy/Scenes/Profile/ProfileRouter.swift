//
//  ProfileRouter.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfileRoutingLogic {
    func showSignOutResultAlert()
    func showSignOutQuestionAlert(completion: @escaping (() -> Void))
    func routeToLogin()
    func routeToPost(id: Int, url: String)
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: ProfileRoutingLogic, ProfileDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?

    
    func showSignOutQuestionAlert(completion: @escaping (() -> Void)) {
        viewController?.showAlertWithTwoButtons(title: "Are you sure?", firstButtonTitle: "Yes", secondButtonTitle: "No", firstButtonAction: completion, secondButtonAction: nil)
    }
    
    func showSignOutResultAlert() {
        viewController?.showNoButtonAlert(title: "You are logged out")
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        var destinationDS = destinationVC.router!.dataStore!
        navigateToLogin(source: viewController!, destination: destinationVC)
        passDataToLoginScene(source: dataStore!, destination: &destinationDS)
    }
    
    func navigateToLogin(source: ProfileViewController, destination: LoginViewController) {
        let navController = UINavigationController(rootViewController: destination)
        navController.modalPresentationStyle = .automatic
        navController.modalTransitionStyle = .coverVertical
        viewController?.present(navController, animated: true, completion: nil)
    }
    
    func passDataToLoginScene(source: ProfileDataStore, destination: inout LoginDataStore) {
        destination.loginSceneDelegate = viewController
    }
    
    func routeToPost(id: Int, url: String) {
        let destinationVC = PostViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPost(postID: id, imageURL: url, source: dataStore!, destination: &destinationDS)
        navigateToPost(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPost(source: ProfileViewController, destination: PostViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToPost(postID: Int, imageURL: String, source: ProfileDataStore, destination: inout PostDataStore) {
        destination.id = postID
        let imageView = source.imageView
        imageView?.set(imageURL: imageURL)
        destination.image = imageView?.image ?? UIImage()
        destination.averageColor = imageView?.image?.averageColor ?? UIColor.blueButton
    }
}
