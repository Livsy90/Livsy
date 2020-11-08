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
}
