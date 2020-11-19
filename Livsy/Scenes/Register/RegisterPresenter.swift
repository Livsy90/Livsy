//
//  RegisterPresenter.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol RegisterPresentationLogic {
    func presentRegister(response: RegisterModels.Register.Response)
    func presentLogin(response: RegisterModels.Login.Response)
}

final class RegisterPresenter: RegisterPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: RegisterDisplayLogic?
    
    func presentRegister(response: RegisterModels.Register.Response) {
        viewController?.displayLogin(viewModel: RegisterModels.Register.ViewModel(error: response.error))
    }
    
    func presentLogin(response: RegisterModels.Login.Response) {
        viewController?.displayLogin(viewModel: RegisterModels.Login.ViewModel(error: response.error, username: response.username, password: response.password))
    }
    
}
