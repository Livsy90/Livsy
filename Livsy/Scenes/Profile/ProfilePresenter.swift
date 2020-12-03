//
//  ProfilePresenter.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentSignOut()
    func presentFavPosts(response: ProfileModels.FavoritePosts.Response)
    func presentRemovedPost(response: ProfileModels.PostToRemove.Response)
    func presentAvatar(response: ProfileModels.Avatar.Response)
    func presentPost(response: ProfileModels.PostPage.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: ProfileDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    func presentSignOut() {
        viewController?.displaySignOut()
    }
    
    func presentFavPosts(response: ProfileModels.FavoritePosts.Response) {
        viewController?.displayFavPosts(viewModel: ProfileModels.FavoritePosts.ViewModel())
    }
    
    func presentRemovedPost(response: ProfileModels.PostToRemove.Response) {
        viewController?.displayPostRemoval(viewModel: ProfileModels.PostToRemove.ViewModel(indexPath: response.indexPath))
    }
    
    func presentAvatar(response: ProfileModels.Avatar.Response) {
        viewController?.displayAvatar(viewModel: ProfileModels.Avatar.ViewModel())
    }
    
    func presentPost(response: ProfileModels.PostPage.Response) {
        viewController?.displayPost(viewModel: ProfileModels.PostPage.ViewModel())
    }
}
