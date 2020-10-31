//
//  LoginPresenter.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol LoginPresentationLogic {
    func presentLogin(response: LoginModels.Login.Response)
    func presentResetPassword(response: LoginModels.ResetPassword.Response)
}

final class LoginPresenter: LoginPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: LoginDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentLogin(response: LoginModels.Login.Response) {
        viewController?.displayLogin(viewModel: LoginModels.Login.ViewModel(error: response.error, dismissMode: response.dismissMode))
    }
    
    func presentResetPassword(response: LoginModels.ResetPassword.Response) {
        viewController?.displayResetPassword(viewModel: LoginModels.ResetPassword.ViewModel(result: response.result, error: response.error))
    }
}
