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
            let error: CustomError?
            
        }
        
        struct ViewModel {
            let error: CustomError?
        }
    }
    
}

struct RegisterRespose: Codable  {
    var code: Int
    var id: Int
    var message: String
}
