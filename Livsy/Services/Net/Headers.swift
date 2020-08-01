//
//  Headers.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct Headers {
    
    enum FieldName: String {
        case ContentType = "content-type"
        case Authorization = "authorization"
    }
    
    enum FieldValue: String {
        case Json = "application/json"
    }
    
    enum Request {
        case PostList
        case PostPage
        case PostComments
        case Login
        case CreateComment
        
        internal func dict() -> [String: String] {
            switch self {
            case .PostList:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            case .PostPage:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            case .PostComments:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            case .Login:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            case .CreateComment:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                dictionary[FieldName.Authorization.rawValue] = "Bearer \(UserDefaults.standard.token ?? "")"
                return dictionary
            }
        }
    }
    
}

