//
//  PostListModels.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct Post: Codable {
    let id: Int
    let date: String
    let title: Title?
    let excerpt: Excerpt?
    let imgURL: String?
    let link: String
    let content: Content?
    let author: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        case excerpt
        case imgURL = "fimg_url"
        case link
        case content
        case author
    }
}

struct Title: Codable {
    let rendered: String
}

struct Content: Codable {
    let rendered: String?
    let protected: Bool?
}

struct Excerpt: Codable {
    let rendered: String?
    let protected: Bool
}

struct Guid: Codable {
    let rendered: String
}

enum PostListModels {
    
    // MARK: - PostList
    
    enum PostList {
        
        struct Request {
            var page: Int = 1
            var searchTerms: String = ""
        }
        
        struct Response {
            let error: CustomError?
        }
        
        struct ViewModel {
            let isStopRereshing: Bool
        }
    }
    
    // MARK: - FilteredPostList
    
    enum FilteredPostList {
        
        struct Request {
            var isTag: Bool
            var page: Int = 1
            var id: Int
        }
        
        struct Response {
            let error: CustomError?
        }
        
        struct ViewModel {
            let isStopRereshing: Bool
        }
    }
    
    // MARK: - Login
    
    enum Login {
        
        struct Request {
            var username: String
            var password: String
        }
        
        struct Response {
            let error: CustomError?
            
        }
        
        struct ViewModel {
            let error: CustomError?
        }
    }
    
    // MARK: - Tags
    
    enum Tags {
        
        struct Request {
            var isTags: Bool
        }
        
        struct Response {
            var isTags: Bool
        }
        
        struct ViewModel {
            var isTags: Bool
        }
    }
    
    enum PageList {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostPage {
        
        struct Request {
            var post: Post
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostFromLink {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
}
