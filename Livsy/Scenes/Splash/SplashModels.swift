//
//  SplashModels.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

enum SplashModels {
    
    // MARK: -
    
    enum Login {
        
        struct Request {
            var username: String
            var password: String
        }
        
        struct Response {
            let error: Error?
            
        }
        
        struct ViewModel {
            let error: Error?
        }
    }
    
}
