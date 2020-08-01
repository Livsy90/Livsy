//
//  PostListInteractor.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PostListBusinessLogic {
    func fetchPostList(request: PostListModels.PostList.Request)
    
}

protocol PostListDataStore {
    var postList: [Post] { get set }
}

final class PostListInteractor: PostListBusinessLogic, PostListDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostListPresentationLogic?
    var worker: PostListWorker?
   
    // MARK: - Data Store
    
    var postList: [Post] = []
    
    // MARK: - Business Logic
    
    func fetchPostList(request: PostListModels.PostList.Request) {
        worker?.fetchPostList(page: request.page, completion: { [weak self] (postList, error) in
            guard let self = self else { return }
            if request.page != 1 {
                self.postList.append(contentsOf: postList ?? [])
            } else {
                self.postList = postList ?? []
            }
                       
            let response = PostListModels.PostList.Response(error: error)
            self.presenter?.presentPostList(response: response)
        })
    }
}
