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
    func fetchAuthorName(request: PostModels.AuthorName.Request)
}

protocol PostDataStore {
    var authorName: String? { get set }
    var comments: [PostComment] { get set }
    var image: UIImage { get set }
    var averageColor: UIColor { get set }
    var post: Post { get set }
}

final class PostInteractor: PostBusinessLogic, PostDataStore {

    // MARK: - Public Properties
    
    var presenter: PostPresentationLogic?
    var worker: PostWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var authorName: String?
    var comments: [PostComment] = []
    var image = UIImage()
    var averageColor: UIColor = .blueButton
    var post: Post = Post(id: 00, date: "", title: nil, excerpt: nil, imgURL: nil, link: "", content: nil, author: 00)
    
    // MARK: - Business Logic
    
    func fetchPostPage(request: PostModels.PostPage.Request) {
        averageColor = image.averageColor ?? .blueButton
        presenter?.presentPostPage(response: PostModels.PostPage.Response())
    }
    
    func fetchPostComments(request: PostModels.PostComments.Request) {
        worker?.fetchPostComments(id: post.id, completion: { [weak self] (comments, error) in
            guard let self = self else { return }
            self.comments = comments ?? []
            self.presenter?.presentPostComments(response: PostModels.PostComments.Response())
        })
    }
    
    func savePostToFav(request: PostModels.SaveToFavorites.Request) {
        var array = UserDefaults.favPosts ?? []
        var isFavorite = false
        
        if array.contains(post.id) {
            array = array.filter { $0 != post.id }
            UserDefaults.standard.set(array, forKey: "favPosts")
            isFavorite = false
        } else {
            array.append(post.id)
            UserDefaults.standard.set(array, forKey: "favPosts")
            isFavorite = true
        }
        presenter?.presentPresentFavorites(response: PostModels.SaveToFavorites.Response(isFavorite: isFavorite))
    }
    
    func fetchAuthorName(request: PostModels.AuthorName.Request) {
        worker?.fetchUserInfo(id: post.author, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.authorName = response?.name
            self.presenter?.presentPresentAuthorName(response: PostModels.AuthorName.Response())
        })
    }
    
}
