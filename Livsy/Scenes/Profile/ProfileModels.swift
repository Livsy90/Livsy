//
//  ProfileModels.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

enum ProfileModels {
    
    // MARK: -
    
    enum FavoritePosts {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostToRemove {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let indexPath: IndexPath
        }
        struct ViewModel {
            let indexPath: IndexPath
        }
    }
    
    enum Avatar {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
}

struct UserInfo: Codable {
    var id: Int
    var avatarURLs: avatarURLs
    
    private enum CodingKeys: String, CodingKey {
        case id
        case avatarURLs = "avatar_urls"
    }
}

struct avatarURLs: Codable {
    var small: String
    var madium: String
    var large: String
    
    private enum CodingKeys: String, CodingKey {
        case small = "24"
        case madium = "48"
        case large = "96"
    }
}
