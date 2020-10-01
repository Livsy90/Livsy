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
    
    func fetchPostList(page: Int, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.PostList.get(path: "wp/v2/posts?_embed&page=\(page)")
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.PostListAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
