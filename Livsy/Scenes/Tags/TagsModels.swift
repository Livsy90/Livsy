//
//  TagsModels.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

enum TagsModels {
  
  // MARK: - 
  
  enum Tags {
    
    struct Request {
      
    }
    
    struct Response {
      
    }
    
    struct ViewModel {
      
    }
  }
  
}

struct Tag: Codable {
    var id: Int
    var count: Int
    var name: String
}
