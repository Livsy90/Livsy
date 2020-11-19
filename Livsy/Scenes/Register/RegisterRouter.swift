//
//  RegisterRouter.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol RegisterRoutingLogic {
    func showAlert(with message: String)
    func dismissSelf(username: String, password: String)
}

protocol RegisterDataPassing {
    var dataStore: RegisterDataStore? { get }
}

final class RegisterRouter: RegisterRoutingLogic, RegisterDataPassing {
    
    // MARK: - Public Properties
    
    weak var viewController: RegisterViewController?
    var dataStore: RegisterDataStore?
    
    func showAlert(with message: String) {
        viewController?.showAlertWithOneButton(title: message.pureString(), message: nil, buttonTitle: "OK", buttonAction: nil)
    }
    
    func dismissSelf(username: String, password: String) {
        UserDefaults.standard.username = username
        UserDefaults.standard.password = password
        viewController?.navigationController?.popViewController(animated: true)
    }
}
