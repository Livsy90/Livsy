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
    
    func fetchPostList(page: Int, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        netManager.fetchPostList(page: page, completion: completion)
    }
    
}
