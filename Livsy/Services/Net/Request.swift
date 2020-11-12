//
//  Request.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct Request {
    enum RequestType {
        case PostList
        case PostPage
        case PostComments
        case Login(String, String)
        case CreateComment(String, Int, Int)
        case Register(String, String, String)
        case PasswordReset(String)
        case Search
        case UserInfo
        
        func get(path: String) -> URLRequest {
            guard let url = Server.getBaseUrl(path: path) else { fatalError() }
            var body: Data?
            var headers: [String: String] = [:]
            var request = URLRequest(url: url)
            
            switch self {
            case .PostList:
                request.httpMethod = "GET"
            case .PostPage:
                request.httpMethod = "GET"
            case .PostComments:
                request.httpMethod = "GET"
            case .Login(let username, let password):
                request.httpMethod = "POST"
                body = Bodies.BodyType.Login(username, password).bodyData()
                headers = Headers.Request.Login.dict()
            case .CreateComment(let content, let post, let parent):
                request.httpMethod = "POST"
                body = Bodies.BodyType.CreateComment(content, post, parent).bodyData()
                headers = Headers.Request.CreateComment.dict()
            case .Register(let username, let email, let password):
                request.httpMethod = "POST"
                body = Bodies.BodyType.Register(username, email, password).bodyData()
                headers = Headers.Request.Register.dict()
            case .PasswordReset(let login):
                request.httpMethod = "POST"
                body = Bodies.BodyType.PasswordReset(login).bodyData()
                headers = Headers.Request.PasswordReset.dict()
            case .Search:
                request.httpMethod = "GET"
            case .UserInfo:
                request.httpMethod = "GET"
                headers = Headers.Request.UserInfo.dict()
                request = addHeadersInRequest(headers: headers, urlRequest: request)
            }
            
            if request.httpMethod != "GET" {
                guard let httpBody = body else { fatalError() }
                request.httpBody = httpBody
                request = addHeadersInRequest(headers: headers, urlRequest: request)
            }
            
            return request
        }
        
        internal func addHeadersInRequest(headers: [String: String], urlRequest: URLRequest) -> URLRequest {
            var requestWithHeaders = urlRequest
            for (name, value) in headers {
                requestWithHeaders.setValue(value, forHTTPHeaderField: name)
            }
            return requestWithHeaders
        }
    }
    
}
