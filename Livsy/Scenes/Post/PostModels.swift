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
    let content: Content?
    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case content
//
//    }
    
}

struct PostComment: Codable {
    
    var id: Int
    var parent: Int
    var authorName: String
    var content: Content?
    var replies: [PostComment] = []
//    
//    init(id: Int, parent: Int, authorName: String, content: Content? = nil) {
//        self.id = id
//        self.parent = parent
//        self.authorName = authorName
//        self.content = content
//    }
    
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
    
}


