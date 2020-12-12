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
        return UIColor.init(named: "NavBarTint") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var postBackground: UIColor {
        return UIColor.init(named: "PostBackground") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    static var bodyText: UIColor {
        return UIColor.init(named: "CommentText") ?? .darkText
    }
    
    static var postListText: UIColor {
        return UIColor.init(named: "PostListText") ?? .darkText
    }
    
    static var postListBackground: UIColor {
        return UIColor.init(named: "PostListBackground") ?? .darkText
    }
    
    static var inputAC: UIColor {
        return UIColor.init(named: "InputAC") ?? .darkText 
    }
    
    static var titleGray: UIColor {
        return UIColor.init(named: "TitleGray") ?? .darkText
    }
    
    static var inputTextView: UIColor {
        return UIColor.init(named: "InputTextView") ?? .darkText
    }
    
    static var inputField: UIColor {
        return UIColor.init(named: "InputField") ?? .darkText
    }
    
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
