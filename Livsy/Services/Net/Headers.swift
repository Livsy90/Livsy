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
        case Login
        case CreateComment
        case Register
        
        internal func dict() -> [String: String] {
            switch self {
            case .Login:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            case .CreateComment:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                dictionary[FieldName.Authorization.rawValue] = "Bearer \(UserDefaults.standard.token ?? "")"
                return dictionary
            case .Register:
                var dictionary: [String: String] = [:]
                dictionary[FieldName.ContentType.rawValue] = FieldValue.Json.rawValue
                return dictionary
            }
        }
    }
    
}

