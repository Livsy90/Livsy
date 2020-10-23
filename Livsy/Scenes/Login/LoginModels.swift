//
//  LoginModels.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct LoginResponse: Codable {
    var token: String
    var userEmail: String
    var userNicename: String
    var userDisplayName: String
    
    private enum CodingKeys: String, CodingKey {
        case token
        case userEmail = "user_email"
        case userNicename = "user_nicename"
        case userDisplayName = "user_display_name"
    }
}

struct LoginError {
    var code: String
    var message: String
    var data: LoginErrorData
}

struct LoginErrorData {
    var status: Int
}

enum LoginModels {
    
    // MARK: - 
    
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
    
}
