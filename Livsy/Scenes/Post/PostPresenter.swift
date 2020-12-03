//
//  PostPresenter.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostPresentationLogic {
    func presentPostPage(response: PostModels.PostPage.Response)
    func presentPostComments(response: PostModels.PostComments.Response)
    func presentPresentFavorites(response: PostModels.SaveToFavorites.Response)
    func presentPresentAuthorName(response: PostModels.AuthorName.Response)
}

final class PostPresenter: PostPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PostDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentPostPage(response: PostModels.PostPage.Response) {
        viewController?.displayPostPage(viewModel: PostModels.PostPage.ViewModel())
    }
    
    func presentPostComments(response: PostModels.PostComments.Response) {
        viewController?.displayPostComments(viewModel: PostModels.PostComments.ViewModel())
    }
    
    func presentPresentFavorites(response: PostModels.SaveToFavorites.Response) {
        viewController?.displayFavorites(viewModel: PostModels.SaveToFavorites.ViewModel(isFavorite: response.isFavorite))
    }
    
    func presentPresentAuthorName(response: PostModels.AuthorName.Response) {
        viewController?.displayAuthorName(viewModel: PostModels.AuthorName.ViewModel())
    }
}
