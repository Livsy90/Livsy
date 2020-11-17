//
//  PostListModels.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct Post: Codable { // codable для userDefaults
    let id: Int
    let date: String
    let title: Title?
    let excerpt: Excerpt?
    let imgURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        case excerpt
        case imgURL = "fimg_url"
    }
}
    
struct Title: Codable {
    let rendered: String
}

struct Content: Codable {
    let rendered: String?
    let protected: Bool?
}

struct Excerpt: Codable {
    let rendered: String?
    let protected: Bool
}
    
struct Guid: Codable {
    let rendered: String
}

struct Constants {
    static let topDistanceToView: CGFloat = 20
    static let leftDistanceToView: CGFloat = 20
    static let rightDistanceToView: CGFloat = 20
    static let postListMinimumLineSpacing: CGFloat = 20
    static let postListItemWHeight: CGFloat = 260
    static let postListImageHeight: CGFloat = 130
    static let postListItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.postListMinimumLineSpacing / 2))// / 2
    static var imageWidth: CGFloat = UIScreen.main.bounds.height * 0.18
//        var width = CGFloat()
//        switch UIDevice.current.orientation.isLandscape {
//        case true:
//            width = UIScreen.main.bounds.height * 0.18
//        case false:
//            width = UIScreen.main.bounds.width * 0.18
//        }
//        return width
//    }()
}

enum PostListModels {
  
  // MARK: - 
  
  enum PostList {
    
    struct Request {
        var page: Int = 1
        var searchTerms: String = ""
    }
    
    struct Response {
        let error: CustomError?
    }
    
    struct ViewModel {
        let isStopRereshing: Bool
    }
  }
    
    enum FilteredPostList {
      
      struct Request {
        var isTag: Bool
          var page: Int = 1
          var id: Int
      }
      
      struct Response {
          let error: CustomError?
      }
      
      struct ViewModel {
          let isStopRereshing: Bool
      }
    }
    
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
    
    enum Tags {
      
      struct Request {
        var isTags: Bool
      }
      
      struct Response {
        var isTags: Bool
      }
      
      struct ViewModel {
        var isTags: Bool
      }
    }
  
}
