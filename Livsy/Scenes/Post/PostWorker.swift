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
        let request = Request.RequestType.PostList.get(path: "wp/v2/posts/\(id)")
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.PostPageAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func fetchPostComments(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        netManager.fetchPostComments(id: id, completion: completion)
    }
    
}
