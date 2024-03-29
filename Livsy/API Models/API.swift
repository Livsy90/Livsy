//
//  API.swift
//  Livsy
//
//  Created by Artem on 23.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "intentapp.ru"

    static let postList = "wp/v2/posts?_embed&page="
    static let pageList = "wp/v2/pages"
    static let postsByCategoty = "wp/v2/posts?_embed&categories="
    static let postsByTag = "wp/v2/posts?_embed&tags="
    static let post = "wp/v2/posts/" 
    static let createComment = "wp/v2/comments/"
    static let postComments = "wp/v2/comments/?post="
    static let commentReplies = "wp/v2/comments/?parent="
    static let login = "jwt-auth/v1/token"
    static let signUp = "wp/v2/users/register"
    static let resetPassword = "wp/v2/users/lost-password"
    static let search = "wp/v2/posts?search="
    static let userComments = "wp/v2/comments/?author_name="
    static let favPosts = "wp/v2/posts?include="
    static let currentUserInfo = "wp/v2/users/me"
    static let userInfo = "wp/v2/users/"
    static let tags = "wp/v2/tags"
    static let categories = "wp/v2/categories"
}
