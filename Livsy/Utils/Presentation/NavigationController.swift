//
//  NavigationController.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarUpdateAnimation
        }
        
        return .slide 
    }
}
