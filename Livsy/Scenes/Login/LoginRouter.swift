//
//  LoginRouter.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol LoginRoutingLogic {
    func showErrorAlert(with message: String, completion: @escaping (() -> Void))
    func showResetPasswordAlert(completion: @escaping ((String) -> Void))
    func showPasswordResultAlert(with message: String)
    func showResetPasswordErrorAlert(with message: String)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    func showErrorAlert(with message: String, completion: @escaping (() -> Void) ) {
        viewController?.showAlertWithTwoButtons(title: String(htmlEncodedString: message) ?? "Error", firstButtonTitle: "OK", secondButtonTitle: "Forgot password?", firstButtonAction: nil, secondButtonAction: completion)
    }
    
    func showResetPasswordAlert(completion: @escaping ((String) -> Void)) {
        viewController?.showAlertWithTextField(placeHolder: "Login or email", title: "Forgot password?", firstButtonTitle: "Send instructions", secondButtonTitle: "Cancel", firstButtonAction: completion, secondButtonAction: nil)
    }
    
    func showPasswordResultAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message, message: nil, buttonTitle: "OK", buttonAction: nil)
    }
    
    func showResetPasswordErrorAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: String(htmlEncodedString: message) ?? "Error", message: nil, buttonTitle: "OK", buttonAction: nil)
    }

}
