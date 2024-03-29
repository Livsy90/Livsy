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
    func search(request: PostListModels.PostList.Request)
    func login(request: PostListModels.Login.Request)
    func signOut()
    func fetchFilterData(request: PostListModels.Tags.Request)
    func fetchFilteredPostList(request: PostListModels.FilteredPostList.Request)
    func fetchPageList(request: PostListModels.PageList.Request)
    func showPost(request: PostListModels.PostPage.Request)
}

protocol PostListDataStore {
    var postList: [Post] { get set }
    var tags: [Tag] { get set }
    var categories: [Tag] { get set }
    var pageList: [Post] { get set }
    var imageView: WebImageView { get set }
    var selectedPost: Post { get set }
}

final class PostListInteractor: PostListBusinessLogic, PostListDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostListPresentationLogic?
    var worker: PostListWorker?
    
    // MARK: - Data Store
    
    var postList: [Post] = []
    var selectedPost: Post = Post(id: 00, date: "", title: nil, excerpt: nil, imgURL: nil, link: "", content: nil, author: 00)
    var tags: [Tag] = []
    var categories: [Tag] = []
    var pageList: [Post] = []
    var imageView: WebImageView = WebImageView()
    
    // MARK: - Business Logic
    
    func fetchPostList(request: PostListModels.PostList.Request) {
        if request.searchTerms != "" {
            search(request: request)
        } else {
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
    
    func login(request: PostListModels.Login.Request) {
        worker?.login(login: request.username, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            #if DEBUG
            print(UserDefaults.standard.token)
            #endif
            
            if error == nil {
                UserDefaults.standard.token = response?.token
                UserDefaults.standard.username = response?.userDisplayName
                UserDefaults.standard.password = request.password
            } else {
                UserDefaults.standard.token = ""
                UserDefaults.standard.username = ""
                UserDefaults.standard.password = ""
            }
            self.presenter?.presentToken(response: PostListModels.Login.Response(error: error))
        })
    }
    
    func signOut() {
        UserDefaults.standard.token = ""
        UserDefaults.standard.username = ""
        UserDefaults.standard.password = ""
        presenter?.presentSignOut()
    }
    
    func search(request: PostListModels.PostList.Request) {
        worker?.fetchSearchResults(searchTerms: request.searchTerms, completion: { (response, error) in
            self.postList = response ?? []
            let customError = CustomError(code: "00", message: "searh", data: ErrorData(status: 00))
            let response = PostListModels.PostList.Response(error: customError)
            self.presenter?.presentPostList(response: response)
        })
    }
    
    func fetchFilterData(request: PostListModels.Tags.Request){
        worker?.fetchTags(isTags: request.isTags, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            request.isTags ? (self.tags = response ?? []) : (self.categories = response ?? [])
            self.presenter?.presentTags(response: PostListModels.Tags.Response(isTags: request.isTags))
        })
    }
    
    func fetchFilteredPostList(request: PostListModels.FilteredPostList.Request) {
        
        worker?.fetchPostListByCategory(page: request.page, id: request.id, isTag: request.isTag, completion: { [weak self] (postList, error) in
            
            guard let self = self else { return }
            if request.page != 1 && error == nil {
                self.postList.append(contentsOf: postList ?? [Post(id: 0, date: "", title: Title(rendered: "no title"), excerpt: nil, imgURL: "", link: "", content: nil, author: 00)])
            } else if error == nil {
                self.postList = postList ?? []
            }
            
            if error == nil && postList?.isEmpty ?? true {
                let error = CustomError(code: "", message: "something went wrong...", data: ErrorData(status: 0))
                let response = PostListModels.FilteredPostList.Response(error: error)
                self.presenter?.presentPostListByCategory(response: response)
            } else {
                let response = PostListModels.FilteredPostList.Response(error: error)
                self.presenter?.presentPostListByCategory(response: response)
            }
            
        })
    }
    
    func fetchPageList(request: PostListModels.PageList.Request) {
        worker?.fetchPageList(completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.pageList = response ?? []
            self.presenter?.presentPageList(response: PostListModels.PageList.Response())
        })
    }
    
    func showPost(request: PostListModels.PostPage.Request) {
        imageView.set(imageURL: request.post.imgURL, isThumbnail: false)
        selectedPost = request.post
        presenter?.presentPost(response: PostListModels.PostPage.Response())
    }
    
}
