//
//  PostListWorker.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostListWorker {
    let net: NetService = NetService.sharedInstanse
    let netManager: NetManager = NetManager.sharedInstanse
    
    func fetchPostList(page: Int, completion: @escaping (Bodies.PostListAPI.Response?, CustomError?) -> ()) {
        netManager.fetchPostList(page: page, completion: completion)
    }
    
    func fetchSearchResults(searchTerms: String, completion: @escaping (Bodies.PostListAPI.Response?, CustomError?) -> ()) {
        netManager.fetchSearchResults(searchTerms: searchTerms, completion: completion)
    }
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, CustomError?) -> ()) {
        netManager.login(login: login, password: password, completion: completion)
    }
    
    func fetchTags(completion: @escaping (Bodies.TagsAPI.Response?, CustomError?) -> ()) {
        netManager.fetchTags(completion: completion)
    }
}
