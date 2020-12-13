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
            var isSubmitted: Bool
        }
        
        struct Response {
            var isReload: Bool
            var isOneCommentAppended: Bool
            var isSubmited: Bool
            var isEditedByWeb: Bool
        }
        
        struct ViewModel {
            var isReload: Bool
            var isOneCommentAppended: Bool
            var isSubmited: Bool
            var isEditedByWeb: Bool
        }
    }
    
    enum SubmitComment {
        
        struct Request {
            var content: String
            var post: Int
        }
        
        struct Response {
            var error: CustomError?
        }
        
        struct ViewModel {
            var error: CustomError?
        }
    }
    
}
