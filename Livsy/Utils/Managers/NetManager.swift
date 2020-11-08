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
    
    func decodeError(data: Data) -> CustomError? {
        do {
            let response = try JSONDecoder().decode(CustomError.self, from: data)
            return response
        } catch {
            return nil
        }
    }
    
    func fetchPostComments(id: Int, completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        let perPageQuery = "&per_page=100"
        let request = Request.RequestType.PostComments.get(path: "\(API.postComments)\(id)\(perPageQuery)")
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
    
    func fetchFavoritePosts(postsIds: String, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.PostList.get(path: "\(API.favPosts)\(postsIds)")
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
    
    func createComment(content: String, post: Int, parent: Int, completion: @escaping (Bodies.CreateCommentAPI.Response?, CustomError?) -> ()) {
        let request = Request.RequestType.CreateComment(content, post, parent).get(path: API.createComment)
        net.getData(with: request) { (data, error) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.CreateCommentAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                guard let cusotomError = self.decodeError(data: data) else { return }
                completion(nil, cusotomError)
            }
        }
        
    }
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, CustomError?) -> ()) {
        let request = Request.RequestType.Login(login, password).get(path: API.login)
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.LoginAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                guard let cusotomError = self.decodeError(data: data) else { return }
                completion(nil, cusotomError)
            }
        }
    }
    
    func resetPassword(login: String, completion: @escaping (Bodies.PasswordResetAPI.Response?, CustomError?) -> ()) {
        let request = Request.RequestType.PasswordReset(login).get(path: API.resetPassword)
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.PasswordResetAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                guard let cusotomError = self.decodeError(data: data) else { return }
                completion(nil, cusotomError)
            }
        }
    }
    
    func register(username: String, email: String, password: String, completion: @escaping (Bodies.RegisterAPI.Response?, CustomError?) -> ()) {
        let request = Request.RequestType.Register(username, email, password).get(path: API.signUp)
        net.getData(with: request) { (data, error) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.RegisterAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                guard let customError = self.decodeError(data: data) else { return }
                completion(nil, customError)
            }
        }
    }
    
    func fetchPostList(page: Int, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.PostList.get(path: "\(API.postList)\(page)")
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
    
    func fetchPost(id: Int, completion: @escaping (Bodies.PostPageAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.PostList.get(path: "\(API.post)\(id)")
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
    
    func fetchSearchResults(searchTerms: String, completion: @escaping (Bodies.PostListAPI.Response?, Error?) -> ()) {
        print("wp/v2/posts?search=" + searchTerms)
        let request = Request.RequestType.Search.get(path: "wp/v2/posts?search=\(searchTerms)")
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
