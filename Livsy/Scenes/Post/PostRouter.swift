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
    func showAddToFavResultAlert(with text: String)
    func showErrorAlert(with message: String, completion: @escaping (() -> Void))
    func dismissSelf()
    func sharePost()
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
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToPostComments(source: PostDataStore, destination: inout PostCommentsDataStore) {
        destination.commentsData = source.comments
        destination.postID = source.id
        destination.postTitle = source.title ?? ""
    }
    
    func showAddToFavResultAlert(with text: String) {
        viewController?.showNoButtonAlert(title: text)
    }
    
    func showErrorAlert(with message: String, completion: @escaping (() -> Void)) {
        viewController?.showAlertWithTwoButtons(title: message, firstButtonTitle: "Dismiss", secondButtonTitle: "Retry", firstButtonAction: dismissSelf, secondButtonAction: completion)
    }
    
    func dismissSelf() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func sharePost() {
        let linkActivityItem = NSURL(string: dataStore?.postLink ?? "")!
        let activityViewController = UIActivityViewController(
            activityItems: [linkActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController?.shareButton
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.isModalInPresentation = true
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}
