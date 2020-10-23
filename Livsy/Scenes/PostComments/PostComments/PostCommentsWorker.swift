//
//  PostCommentsWorker.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostCommentsWorker {
    
    private let net = NetService.sharedInstanse
    private let netManager = NetManager.sharedInstanse
    
    func createComment(content: String, post: Int, parent: Int, completion: @escaping (Bodies.CreateCommentAPI.Response?, CustomError?) -> ()) {
        netManager.createComment(content: content, post: post, parent: parent, completion: completion)
    }
    
    func fetchPostComments(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        netManager.fetchPostComments(id: id, completion: completion)
    }
    
}
