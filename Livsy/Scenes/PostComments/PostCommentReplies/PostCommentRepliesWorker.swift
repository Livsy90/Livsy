//
//  PostCommentRepliesWorker.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostCommentRepliesWorker {
    
    // MARK: - Private Properties
    
    private let net = NetService.sharedInstanse
    private let netManager = NetManager.sharedInstanse
    
    // MARK: - Working Logic
    
    func createComment(content: String, post: Int, parent: Int, completion: @escaping (Bodies.CreateCommentAPI.Response?, Error?) -> ()) {
        netManager.createComment(content: content, post: post, parent: parent, completion: completion)
    }
    
    func fetchReplies(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.PostList.get(path: "\(API.commentReplies)\(id)")
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.PostCommentsAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion([], error)
            }
        }
        
    }
}
