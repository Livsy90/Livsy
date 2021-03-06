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
    func dismissSelf(mode: LoginModels.Mode)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    func showErrorAlert(with message: String, completion: @escaping (() -> Void) ) {
        viewController?.showAlertWithTwoButtons(title: message.pureString(), firstButtonTitle: Text.Login.forgotPassword, secondButtonTitle: Text.Common.tryAgain, firstButtonAction: completion, secondButtonAction: nil)
    }
    
    func showResetPasswordAlert(completion: @escaping ((String) -> Void)) {
        viewController?.showAlertWithTextField(placeHolder: Text.Login.logingOrEmail, title: Text.Login.forgotPassword, firstButtonTitle: Text.Login.sendInstructions, secondButtonTitle: Text.Common.cancel, firstButtonAction: completion, secondButtonAction: nil)
    }
    
    func showPasswordResultAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message, message: nil, buttonTitle: Text.Common.ok, buttonAction: nil)
    }
    
    func showResetPasswordErrorAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message.pureString(), message: nil, buttonTitle: Text.Common.ok, buttonAction: nil)
    }
    
    func dismissSelf(mode: LoginModels.Mode) {
        switch mode {
        case .toProfile:
            let destinationDelegate = dataStore?.loginSceneDelegate
            passDataToLoginScene(source: dataStore!, destination: destinationDelegate)
            viewController?.dismiss(animated: true)
        default:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func passDataToLoginScene(source: LoginDataStore, destination: LoginSceneDelegate?) {
        destination?.setupUIforLoggedIn()
    }

}
