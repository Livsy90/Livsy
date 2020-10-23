//
//  PostWorker.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostWorker {
    
    let net = NetService.sharedInstanse
    let netManager = NetManager.sharedInstanse
    
    func fetchPost(id: Int, completion: @escaping (Bodies.PostPageAPI.Response?, Error?) -> ()) {
        netManager.fetchPost(id: id, completion: completion)
    }
    
    func fetchPostComments(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        netManager.fetchPostComments(id: id, completion: completion)
    }
    
}
