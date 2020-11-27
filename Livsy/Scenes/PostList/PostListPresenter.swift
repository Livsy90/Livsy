//
//  PostListPresenter.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostListPresentationLogic {
    func presentPostList(response: PostListModels.PostList.Response)
    func presentToken(response: PostListModels.Login.Response)
    func presentSignOut()
    func presentTags(response: PostListModels.Tags.Response)
    func presentPostListByCategory(response: PostListModels.FilteredPostList.Response)
    func presentPageList(response: PostListModels.PageList.Response)
    func presentPost(response: PostListModels.Post.Response)
}

final class PostListPresenter: PostListPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PostListDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentPostList(response: PostListModels.PostList.Response) {
        viewController?.displayPostList(viewModel: PostListModels.PostList.ViewModel(isStopRereshing: response.error != nil))
    }
    
    func presentToken(response: PostListModels.Login.Response) {
        viewController?.displayToken(viewModel: PostListModels.Login.ViewModel(error: response.error))
    }
    
    func presentSignOut() {
        viewController?.displaySignOut()
    }
    
    func presentTags(response: PostListModels.Tags.Response) {
        viewController?.displayTags(viewModel: PostListModels.Tags.ViewModel(isTags: response.isTags))
    }
    
    func presentPostListByCategory(response: PostListModels.FilteredPostList.Response) {
        viewController?.displayPostListByCategory(viewModel: PostListModels.FilteredPostList.ViewModel(isStopRereshing: response.error != nil))
    }
    
    func presentPageList(response: PostListModels.PageList.Response) {
        viewController?.displayPageList(viewModel: PostListModels.PageList.ViewModel())
    }
    
    func presentPost(response: PostListModels.Post.Response) {
        viewController?.displayPost(viewModel: PostListModels.Post.ViewModel(id: response.id))
    }
    
}
