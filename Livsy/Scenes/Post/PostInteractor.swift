//
//  PostInteractor.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostBusinessLogic {
    func fetchPostPage(request: PostModels.PostPage.Request)
    func fetchPostComments(request: PostModels.PostComments.Request)
}

protocol PostDataStore {
    var title: String? { get set }
    var content: String? { get set }
    var id: Int { get set }
    var comments: [PostComment] { get set }
    var image: UIImage { get set }
}

final class PostInteractor: PostBusinessLogic, PostDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostPresentationLogic?
    var worker: PostWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var title: String? = ""
    var content: String? = ""
    var id: Int = 1
    var comments: [PostComment] = []
    var image = UIImage()
    
    
    // MARK: - Business Logic
    
    func fetchPostPage(request: PostModels.PostPage.Request) {
        worker?.fetchPost(id: id, completion: { [weak self] (post, error) in
            guard let self = self else { return }
            self.content = post?.content?.rendered
            self.title = post?.title?.rendered
            self.presenter?.presentPostPage(response: PostModels.PostPage.Response())
        })
    }
    
    func fetchPostComments(request: PostModels.PostComments.Request) {
        worker?.fetchPostComments(id: id, completion: { [weak self] (comments, error) in
            guard let self = self else { return }
            self.comments = comments ?? []
            self.presenter?.presentPostComments(response: PostModels.PostComments.Response())
        })
    }
}
