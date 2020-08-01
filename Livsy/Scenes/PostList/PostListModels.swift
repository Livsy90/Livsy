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
    let images: Images?
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

struct Images: Codable {
    let medium: String?
    let large: String?
}

struct Constants {
    static let topDistanceToView: CGFloat = 20
    static let leftDistanceToView: CGFloat = 20
    static let rightDistanceToView: CGFloat = 20
    static let postListMinimumLineSpacing: CGFloat = 20
    static let postListItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.postListMinimumLineSpacing / 2))// / 2
    static var imageWidth: CGFloat = {
        var width = CGFloat()
        switch UIDevice.current.orientation.isLandscape {
        case true:
            width = UIScreen.main.bounds.height * 0.18
        case false:
            width = UIScreen.main.bounds.width * 0.18
        }
        return width
    }()
}

enum PostListModels {
  
  // MARK: - 
  
  enum PostList {
    
    struct Request {
        var page: Int = 1
    }
    
    struct Response {
        let error: Error?
    }
    
    struct ViewModel {
        let isStopRereshing: Bool
    }
  }
  
}
