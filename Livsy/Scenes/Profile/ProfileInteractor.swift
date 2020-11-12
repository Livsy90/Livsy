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
    func removePost(request: ProfileModels.PostToRemove.Request)
    func getAvatar(request: ProfileModels.Avatar.Request)
}

protocol ProfileDataStore {
    var favoritePosts: [Post] { get set }
    var postImageView: WebImageView? { get set }
    var avatar: WebImageView? { get set }
    var url: String { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    
    // MARK: - Public Properties
    
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var favoritePosts: [Post] = []
    var postImageView: WebImageView? = WebImageView()
    var avatar: WebImageView? = WebImageView()
    var url: String = ""
    
    // MARK: - Business Logic
    
    func signOut() {
        UserDefaults.standard.token = ""
        UserDefaults.standard.username = ""
        UserDefaults.standard.password = ""
        url = ""
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
    
    func removePost(request: ProfileModels.PostToRemove.Request) {
        var array = UserDefaults.favPosts ?? []
        array = array.filter { $0 != favoritePosts[request.indexPath.row].id }
        UserDefaults.standard.set(array, forKey: "favPosts")
        favoritePosts.remove(at: request.indexPath.row)
        presenter?.presentRemovedPost(response: ProfileModels.PostToRemove.Response(indexPath: request.indexPath))
    }
    
    func getAvatar(request: ProfileModels.Avatar.Request) {
        worker?.fetchUserInfo(completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.url = response?.avatarURLs.large.getSecureGravatar() ?? ""
            self.avatar?.set(imageURL: response?.avatarURLs.large.getSecureGravatar())
            self.presenter?.presentAvatar(response: ProfileModels.Avatar.Response())
        })
    }
    
}
