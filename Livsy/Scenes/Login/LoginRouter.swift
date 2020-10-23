//
//  LoginRouter.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol LoginRoutingLogic {
    func showAlert(with message: String)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    func showAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: String(htmlEncodedString: message) ?? "Error", message: nil, buttonTitle: "OK", buttonAction: nil)
    }
}
