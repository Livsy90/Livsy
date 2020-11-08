//
//  ProfileInteractor.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol ProfileBusinessLogic {
    func signOut()
    func showFavPosts(request: ProfileModels.FavoritePosts.Request)
}

protocol ProfileDataStore {
    var favoritePosts: [Post] { get set }
    var imageView: WebImageView? { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    
    // MARK: - Public Properties
    
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var favoritePosts: [Post] = []
    var imageView: WebImageView? = WebImageView()
    
    // MARK: - Business Logic
    
    func signOut() {
        UserDefaults.standard.token = ""
        UserDefaults.standard.username = ""
        UserDefaults.standard.password = ""
        presenter?.presentSignOut()
    }
    
    func showFavPosts(request: ProfileModels.FavoritePosts.Request) {
        let favList = UserDefaults.favPosts ?? []
        let stringArray = favList.map(String.init).joined(separator: ",")
        
        if !stringArray.isEmpty {
            worker?.fetchFavoritePosts(postsIds: stringArray, completion: { [weak self] (response, error) in
                guard let self = self else { return }
                self.favoritePosts = response ?? []
                self.presenter?.presentFavPosts(response: ProfileModels.FavoritePosts.Response())
            })
        } else {
            favoritePosts = []
            presenter?.presentFavPosts(response: ProfileModels.FavoritePosts.Response())
        }
    }
    
}
