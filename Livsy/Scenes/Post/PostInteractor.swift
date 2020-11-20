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
    func savePostToFav(request: PostModels.SaveToFavorites.Request)
}

protocol PostDataStore {
    var title: String? { get set }
    var content: String? { get set }
    var id: Int { get set }
    var comments: [PostComment] { get set }
    var image: UIImage { get set }
    var averageColor: UIColor { get set }
    var postLink: String { get set }
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
    var averageColor: UIColor = .blueButton
    var postLink: String = "https://livsy.me"
    
    // MARK: - Business Logic
    
    func fetchPostPage(request: PostModels.PostPage.Request) {
        worker?.fetchPost(id: id, completion: { [weak self] (post, error) in
            guard let self = self else { return }
            self.content = post?.content?.rendered
            self.title = post?.title?.rendered
            self.postLink = post?.link ?? "https://livsy.me"
            self.presenter?.presentPostPage(response: PostModels.PostPage.Response(error: error))
        })
    }
    
    func fetchPostComments(request: PostModels.PostComments.Request) {
        worker?.fetchPostComments(id: id, completion: { [weak self] (comments, error) in
            guard let self = self else { return }
            self.comments = comments ?? []
            self.presenter?.presentPostComments(response: PostModels.PostComments.Response())
        })
    }
    
    func savePostToFav(request: PostModels.SaveToFavorites.Request) {
        var array = UserDefaults.favPosts ?? []
        var isFavorite = false
        
        if array.contains(id) {
            array = array.filter { $0 != id }
            UserDefaults.standard.set(array, forKey: "favPosts")
            isFavorite = false
        } else {
            array.append(id)
            UserDefaults.standard.set(array, forKey: "favPosts")
            isFavorite = true
        }
        presenter?.presentPresentFavorites(response: PostModels.SaveToFavorites.Response(isFavorite: isFavorite))
    }
    
}
