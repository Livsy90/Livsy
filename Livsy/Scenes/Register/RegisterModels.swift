//
//  RegisterModels.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

enum RegisterModels {
    
    // MARK: -
    
  enum Register {
        
        struct Request {
            var username: String
            var email: String
            var password: String
        }
        
        struct Response {
            let error: CustomSignUpError?
            
        }
        
        struct ViewModel {
            let error: CustomSignUpError?
        }
    }
    
    enum Login {
        
        struct Request {
            var username: String
            var password: String
        }
        
        struct Response {
            let error: CustomError?
            var username: String
            var password: String
        }
        
        struct ViewModel {
            let error: CustomError?
            var username: String
            var password: String
        }
    }
    
}

struct RegisterRespose: Codable  {
    var code: Int
    var id: Int
    var message: String
}
