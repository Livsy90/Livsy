//
//  Bodies.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct Bodies {
    
    enum BodyType {
        case PostList
        case PostPage
        case PostComments
        case Login(String, String)
        case CreateComment(String, Int, Int)
        case Register(String, String, String)
        case PasswordReset(String)
        
        func bodyData() -> Data? {
            
            switch self {
            case .PostList:
                guard let httpBody = try? JSONEncoder().encode(PostListAPI.Request()) else { fatalError() }
                return httpBody
            case .PostPage:
                guard let httpBody = try? JSONEncoder().encode(PostPageAPI.Request()) else { fatalError() }
                return httpBody
            case .PostComments:
                guard let httpBody = try? JSONEncoder().encode(PostCommentsAPI.Request()) else { fatalError() }
                return httpBody
            case .Login(let username, let password):
                guard let httpBody = try? JSONEncoder().encode(LoginAPI.Request(username: username, password: password)) else { fatalError() }
                return httpBody
            case .CreateComment(let content, let post, let parent):
                guard let httpBody = try? JSONEncoder().encode(CreateCommentAPI.Request(content: content, post: post, parent: parent)) else { fatalError() }
                return httpBody
            case .Register(let username, let email, let password):
                guard let httpBody = try? JSONEncoder().encode(RegisterAPI.Request(username: username, email: email, password: password)) else { fatalError() }
                return httpBody
           case .PasswordReset(let login):
                guard let httpBody = try? JSONEncoder().encode(PasswordResetAPI.Request(user_login: login)) else { fatalError() }
                return httpBody
            }
        }
    }
    
    // MARK: PostListAPI
    
    enum PostListAPI {
        typealias Response = [Post]
        struct Request: Encodable {
        }
    }
    
    // MARK: PostPageAPI
    
    enum PostPageAPI {
        typealias Response = PostPage
        struct Request: Encodable {
        }
    }
    
    // MARK: PostCommentsAPI
    
    enum PostCommentsAPI {
        typealias Response = [PostComment]
        struct Request: Encodable {
        }
    }
    
    // MARK: LoginAPI
    
    enum LoginAPI {
        typealias Response = LoginResponse
        struct Request: Encodable {
            var username: String
            var password: String
        }
    }
    
    // MARK: CreateCommentAPI
    
    enum CreateCommentAPI {
        typealias Response = PostComment
        struct Request: Encodable {
            var content: String
            var post: Int
            var parent: Int
        }
    }
    
    // MARK: RegisterAPI
    
    enum RegisterAPI {
        typealias Response = RegisterRespose
        struct Request: Encodable {
            var username: String
            var email: String
            var password: String
        }
    }
    
    // MARK: PasswordResetAPI
       
       enum PasswordResetAPI {
           typealias Response = PasswordResetResponse
           struct Request: Encodable {
               var user_login: String
           }
       }
    
}


