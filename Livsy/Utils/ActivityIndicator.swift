//
//  ActivityIndicator.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct ActivityIndicator {
    
    // MARK: Public Properties
    
    let activityIndicator = UIActivityIndicatorView()
    let viewBackgroundLoading = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    
    // MARK: Public Methods
    
    func showIndicator(on viewController: UIViewController) {
        
        activityIndicator.center = viewController.view.center
        activityIndicator.hidesWhenStopped = true
//        activityIndicator.style = .large
        
        viewBackgroundLoading.center = viewController.view.center
        viewBackgroundLoading.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        viewBackgroundLoading.layer.cornerRadius = 20
        viewBackgroundLoading.alpha = 1
        viewBackgroundLoading.clipsToBounds = true
        
        viewController.view.addSubview(viewBackgroundLoading)
        viewController.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        viewBackgroundLoading.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}
