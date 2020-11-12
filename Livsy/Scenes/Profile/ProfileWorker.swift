//
//  ProfileWorker.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class ProfileWorker {
    
    private let net = NetService.sharedInstanse
    private let netManager = NetManager.sharedInstanse
    
    func fetchFavoritePosts(postsIds: String, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        netManager.fetchFavoritePosts(postsIds: postsIds, completion: completion)
    }
    
    func fetchUserInfo(completion: @escaping (Bodies.UserInfoAPI.Response?, CustomError?) -> ()) {
        netManager.fetchUserInfo(completion: completion)
    }
    
}
