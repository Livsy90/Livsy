//
//  NetManager.swift
//  Livsy
//
//  Created by Artem on 28.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

class NetManager {
static let sharedInstanse = NetManager()
private let net: NetService = NetService()
private init(){}

    func fetchPostComments(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        let perPageQuery = "&per_page=100"
        let request = Request.RequestType.PostList.get(path: "\(API.postComments)\(id)\(perPageQuery)")
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
    
    func createComment(content: String, post: Int, parent: Int, completion: @escaping (Bodies.CreateCommentAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.CreateComment(content, post, parent).get(path: API.createComment)
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.CreateCommentAPI.Response.self, from: data)
                completion(response, nil)
                print(response)
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        
    }
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.Login(login, password).get(path: API.login)
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.LoginAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
