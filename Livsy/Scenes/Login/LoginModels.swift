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

struct PasswordResetResponse: Codable {
    var code: Int
    var message: String
}

enum LoginModels {
    
    enum Mode {
        case toProfile
        case toComments
    }
    
    // MARK: Login
    
    enum Login {
        
        struct Request {
            var username: String
            var password: String
        }
        
        struct Response {
            let error: CustomError?
            var dismissMode: LoginModels.Mode
        }
        
        struct ViewModel {
            let error: CustomError?
            var dismissMode: LoginModels.Mode
        }
    }
    
    // MARK: ResetPassword
    
    enum ResetPassword {
        
        struct Request {
            var login: String
        }
        
        struct Response {
            let result: String
            let error: CustomError?
            
        }
        
        struct ViewModel {
            let result: String
            let error: CustomError?
        }
    }
    
}
