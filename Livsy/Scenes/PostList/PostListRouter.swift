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
    func routeTags()
    func routeCategories()
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
        destination.averageColor = imageView.image?.averageColor ?? UIColor.blueButton
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
    
    func routeTags() {
        let destinationVC = TagsViewController()
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToTagList(source: dataStore!, destination: &destinationDS)
        navigateToTagList(source: viewController!, destination: destinationVC)
        
    }
    
    func navigateToTagList(source: PostListViewController, destination: TagsViewController) {
        destination.modalPresentationStyle = .popover
        
        let popOverViewController = destination.popoverPresentationController
        popOverViewController?.delegate = viewController
        popOverViewController?.sourceView = viewController?.tagsButton
        popOverViewController?.permittedArrowDirections = .up
        popOverViewController?.backgroundColor = .clear
        
        guard
            let buttonMidX = viewController?.tagsButton.bounds.midX,
            let buttonMaxY = viewController?.tagsButton.bounds.maxY
            else { return }
        
        popOverViewController?.sourceRect = CGRect(x: buttonMidX, y: buttonMaxY, width: 0, height: 0)
        
        viewController?.present(destination, animated: true, completion: nil)
    }
    
    func passDataToTagList(source: PostListDataStore, destination: inout TagsDataStore) {
        destination.tags = source.tags
    }
    
    func routeCategories() {
        let destinationVC = CategoriesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToCategories(source: dataStore!, destination: &destinationDS)
        navigateToCategories(source: viewController!, destination: destinationVC)
        
    }
    
    func navigateToCategories(source: PostListViewController, destination: CategoriesViewController) {
        destination.modalPresentationStyle = .popover
        
        let popOverViewController = destination.popoverPresentationController
        popOverViewController?.delegate = viewController
        popOverViewController?.sourceView = viewController?.categoriesButton
        popOverViewController?.permittedArrowDirections = .up
        popOverViewController?.backgroundColor = .clear
        
        guard
            let buttonMidX = viewController?.categoriesButton.bounds.midX,
            let buttonMaxY = viewController?.categoriesButton.bounds.maxY
            else { return }
        
        popOverViewController?.sourceRect = CGRect(x: buttonMidX, y: buttonMaxY, width: 0, height: 0)
        
        viewController?.present(destination, animated: true, completion: nil)
    }
    
    func passDataToCategories(source: PostListDataStore, destination: inout CategoriesDataStore) {
        destination.categories = source.categories
    }
    
    
}
