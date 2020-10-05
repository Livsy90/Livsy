//
//  UIColor+adds.swift
//  Livsy
//
//  Created by Artem on 29.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var listBackground: UIColor {
        return UIColor.init(named: "PostListBackground") ?? #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    static var rowBackground: UIColor {
        return UIColor.init(named: "PostListRow") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var navBarTint: UIColor {
        return UIColor.init(named: "NavBartint") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var postBackground: UIColor {
        return UIColor.init(named: "PostBackground") ?? #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
    
    static var postText: UIColor {
        return UIColor.init(named: "PostText") ?? #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    static var blueButton: UIColor {
        return #colorLiteral(red: 0.5019607843, green: 0.6901960784, blue: 0.8784313725, alpha: 1)
    }
    
    static var additionalView: UIColor {
        return UIColor.init(named: "InputAC") ?? #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    static var authorName: UIColor {
        return UIColor.init(named: "AuthorName") ?? .darkText
    }
    
    static var commentBody: UIColor {
        return UIColor.init(named: "CommentText") ?? .darkText
    }
    
    static var postListText: UIColor {
        return UIColor.init(named: "PostListText") ?? .darkText
    }
    
    static var postListBackground: UIColor {
        return UIColor.init(named: "PostListBackground") ?? .darkText
    }
    
    static var TextLight: UIColor {
        return #colorLiteral(red: 0.4784313725, green: 0.4901960784, blue: 0.5176470588, alpha: 1)
    }
    
}
