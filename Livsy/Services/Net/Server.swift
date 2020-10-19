//
//  Server.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct Server {
    static let urlString = "https://livsy.me/wp-json/"
    static func getBaseUrl(path: String) -> URL? {
//        var components = URLComponents()
//        components.scheme = API.scheme
//        components.host = API.host
//        components.path = path
//        components.queryItems = [
//           URLQueryItem(name: "", value: searchTerm),
//           URLQueryItem(name: "", value: format)
//        ]
//        return components.url!
       return URL(string: urlString + path)
    }
}

struct API {
    static let scheme = "https"
    static let host = "livsy.me"

    static let postList = "wp/v2/posts?_embed&page="
    static let post = "wp/v2/posts/"
    static let createComment = "wp/v2/comments/"
    static let postComments = "wp/v2/comments/?post="
    static let commentReplies = "wp/v2/comments/?parent="
    static let login = "jwt-auth/v1/token"
    static let signUp = "wp/v2/users/register"
}
