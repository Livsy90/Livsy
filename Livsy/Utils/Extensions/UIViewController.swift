//
//  UIViewController.swift
//  Livsy
//
//  Created by Artem on 06.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController {
    
    /// Alert with one action button
    ///
    /// - Parameters:
    ///   - title: title for alert
    ///   - message: bogy for alert
    ///   - buttonTitle: alert button title
    ///   - buttonAction: alert button action
    func showAlertWithOneButton(title: String, message: String?, buttonTitle: String, buttonAction: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            buttonAction?()
        }
        alertController.addAction(alertButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Alert with two action buttons
    ///
    /// - Parameters:
    ///   - title: title for alert
    ///   - firstButtonTitle: first button title
    ///   - secondButtonTitle: second button title
    ///   - firstButtonAction: first button action
    ///   - secondButtonAction: second button action
    func showAlertWithTwoButtons(
        title: String,
        firstButtonTitle: String,
        secondButtonTitle: String,
        firstButtonAction: (() -> Void)?,
        secondButtonAction: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let firstAlertButton = UIAlertAction(title: firstButtonTitle, style: .default) { (_) in
            firstButtonAction?()
        }
        let secondAlertButton = UIAlertAction(title: secondButtonTitle, style: .default) { (_) in
            secondButtonAction?()
        }
        
        alertController.addAction(firstAlertButton)
        alertController.addAction(secondAlertButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

