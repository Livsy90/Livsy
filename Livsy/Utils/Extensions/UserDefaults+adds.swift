//
//  UserDefaults+adds.swift
//  Livsy
//
//  Created by Artem on 11.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    
    private enum Key {
        
        static let addPostOpenCount = "addPostOpenCount"
        
        static let login = "login"
        
        static let password = "password"
        
        static let token = "token"
        
        static let favPosts = "favPosts"
    }
    
    var addPostOpenCount: Int? {
        get {
            return integer(forKey: Key.addPostOpenCount)
        }
        set {
            set(newValue, forKey: Key.addPostOpenCount)
        }
    }
    
    var username: String? {
        get {
            return string(forKey: Key.login)
        }
        set {
            set(newValue, forKey: Key.login)
        }
    }
    
    var password: String? {
        get {
            return string(forKey: Key.password)
        }
        set {
            set(newValue, forKey: Key.password)
        }
    }
    
    var token: String? {
        get {
            return string(forKey: Key.token)
        }
        set {
            set(newValue, forKey: Key.token)
        }
    }
    
    static var favPosts: [Int]? {
        get {
            return standard.array(forKey: Key.favPosts) as? [Int]
        }
        set(v) {
            standard.set(v, forKey: Key.favPosts)
        }
    }
    
}
