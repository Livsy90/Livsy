//
//  PostCommentsModels.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct Comment {
    var commentId: Int
    var commentText: String
    var replies: [Comment]
}

final class Reply {
    var parentID: Int
    var replyId: Int
    var replyText: String
    
    init(parentdID: Int, replyId: Int, replyText: String) {
        self.parentID = parentdID
        self.replyId = replyId
        self.replyText = replyText
    }
}


struct SubmitCommentError {
    var code: String
    var message: String
    var data: SubmitCommentErrorData
}

struct SubmitCommentErrorData {
    var statis: Int
}

enum PostCommentsModels {
    
    enum PostComments {
        
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
    
    enum Replies {
        
        struct Request {
            var comment: PostComment
            var replies: [PostComment]?
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
            var error: CustomError?
        }
        
        struct ViewModel {
            var error: CustomError?
        }
    }
    
}
