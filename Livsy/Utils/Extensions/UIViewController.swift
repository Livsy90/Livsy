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
    
    func showAlertWithTextField(
        placeHolder: String,
        title: String,
        firstButtonTitle: String,
        secondButtonTitle: String,
        firstButtonAction: ((String) -> Void)?,
        secondButtonAction: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
        
        let firstAlertButton = UIAlertAction(title: firstButtonTitle, style: .default) { (_) in
            let textField = alertController.textFields![0]
            firstButtonAction?(textField.text ?? "")
        }
        
        let secondAlertButton = UIAlertAction(title: secondButtonTitle, style: .default) { (_) in
            secondButtonAction?()
        }
        
        firstAlertButton.isEnabled = (!(alertController.textFields![0].text?.isEmpty ?? true))
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertController.textFields![0], queue: OperationQueue.main, using:
                {_ in
                    
                    let textCount = alertController.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
        let textIsNotEmpty = textCount > 0
                    firstAlertButton.isEnabled = textIsNotEmpty
        })
        
        alertController.addAction(firstAlertButton)
        alertController.addAction(secondAlertButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNoButtonAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension UIViewController {

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }

}

