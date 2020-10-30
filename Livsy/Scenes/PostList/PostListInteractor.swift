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
    
    func login(request: PostListModels.Login.Request) {
        worker?.login(login: request.username, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            if error == nil {
                UserDefaults.standard.token = response?.token
                UserDefaults.standard.username = response?.userDisplayName
                UserDefaults.standard.password = request.password
            } else {
                UserDefaults.standard.token = ""
                UserDefaults.standard.username = ""
                UserDefaults.standard.password = ""
            }
            print(response?.token)
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
        worker?.fetchSearchResults(searchTerms: "тестовый", completion: { (response, error) in
            self.postList = response ?? []
            let response = PostListModels.PostList.Response(error: error)
            self.presenter?.presentPostList(response: response)
        })
    }
    
}
