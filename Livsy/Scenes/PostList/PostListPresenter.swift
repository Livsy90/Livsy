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
    func presentSignOut()
}

final class PostListPresenter: PostListPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PostListDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentPostList(response: PostListModels.PostList.Response) {
        var isStopRefreshing = false
        
        switch response.error == nil {
        case true:
            isStopRefreshing = false
        case false:
            isStopRefreshing = true
        }
        
        viewController?.displayPostList(viewModel: PostListModels.PostList.ViewModel(isStopRereshing: isStopRefreshing))
    }
    
    func presentSignOut() {
        viewController?.displaySignOut()
    }
    
}
