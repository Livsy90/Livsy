//
//  PostCommentRepliesModels.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

enum PostCommentRepliesModels {
    
    // MARK: -
    
    enum PostCommentReplies {
        
       struct Request {
            var isReload: Bool
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
    
    enum SubmitComment {
        
        struct Request {
            var content: String
            var post: Int
        }
        
        struct Response {
            var error: Error?
        }
        
        struct ViewModel {
            var error: Error?
        }
    }
    
}
