//
//  PostModels.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit


struct PostPage: Codable {
    let id: Int?
    let title: Title?
    let link: String
    let content: Content?
    let author: Int
}

struct PostComment: Codable {
    
    var id: Int
    var parent: Int
    var authorName: String
    var content: Content?
    var replies: [PostComment] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case parent
        case authorName = "author_name"
        case content
    }
    
}

enum PostModels {
    
    enum PostPage {
        
        struct Request {
            var error: CustomError?
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostComments {
        
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
    
    enum SaveToFavorites {
        
        struct Request {
            
        }
        
        struct Response {
            var isFavorite: Bool
        }
        
        struct ViewModel {
            var isFavorite: Bool
        }
    }
    
    enum AuthorName {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum Color {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
}


