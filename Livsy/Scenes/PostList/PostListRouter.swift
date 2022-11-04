//
//  PostListRouter.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostListRoutingLogic {
    func routeToPost()
    func routeToLogin()
    func showSignOutResultAlert()
    func showSignOutQuestionAlert(completion: @escaping (() -> Void))
    func routeToTags()
    func routeToCategories()
    func routeToPageList()
    func routeToPage(id: Int)
}

protocol PostListDataPassing {
    var dataStore: PostListDataStore? { get }
}

final class PostListRouter: PostListRoutingLogic, PostListDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: PostListViewController?
    var dataStore: PostListDataStore?
        
    func routeToPost() {
        let destinationVC = PostViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPost(source: dataStore!, destination: &destinationDS)
        navigateToPost(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPost(source: PostListViewController, destination: PostViewController) {
        destination.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToPost(source: PostListDataStore, destination: inout PostDataStore) {
        destination.image = source.imageView.image ?? UIImage()
        destination.post = source.selectedPost
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
    
    func routeToTags() {
        let destinationVC = TagsViewController()
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToTagList(source: dataStore!, destination: &destinationDS)
        navigateToTagList(source: viewController!, destination: destinationVC)
        
    }
    
    func navigateToTagList(source: PostListViewController, destination: TagsViewController) {
        destination.modalPresentationStyle = .popover
        destination.tagsViewControllerDelegate = viewController
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
    
    func routeToCategories() {
        let destinationVC = CategoriesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToCategories(source: dataStore!, destination: &destinationDS)
        navigateToCategories(source: viewController!, destination: destinationVC)
        
    }
    
    func navigateToCategories(source: PostListViewController, destination: CategoriesViewController) {
        destination.modalPresentationStyle = .popover
        destination.categoriesViewControllerDelegate = viewController
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
    
    func routeToPageList() {
        let destinationVC = PageListViewController()
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToPageList(source: dataStore!, destination: &destinationDS)
        navigateToPageList(source: viewController!, destination: destinationVC)
        
    }
    
    func navigateToPageList(source: PostListViewController, destination: PageListViewController) {
        destination.modalPresentationStyle = .popover
        destination.pageListViewControllerDelegate = viewController
        let popOverViewController = destination.popoverPresentationController
        popOverViewController?.delegate = viewController
        popOverViewController?.sourceView = viewController?.pageListButton
        popOverViewController?.permittedArrowDirections = .up
        popOverViewController?.backgroundColor = .clear
        
        guard
            let buttonMidX = viewController?.pageListButton.bounds.midX,
            let buttonMaxY = viewController?.pageListButton.bounds.maxY
            else { return }
        
        popOverViewController?.sourceRect = CGRect(x: buttonMidX, y: buttonMaxY, width: 0, height: 0)
        
        viewController?.present(destination, animated: true, completion: nil)
    }
    
    func passDataToPageList(source: PostListDataStore, destination: inout PageListDataStore) {
        destination.pageList = source.pageList
    }
    
    func routeToPage(id: Int) {
        let destinationVC = PageViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPage(id: id, source: dataStore!, destination: &destinationDS)
        navigateToPage(source: viewController!, destination: destinationVC)
    }
    
    func navigateToPage(source: PostListViewController, destination: PageViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToPage(id: Int, source: PostListDataStore, destination: inout PageDataStore) {
        destination.id = id
        
    }
    
}
