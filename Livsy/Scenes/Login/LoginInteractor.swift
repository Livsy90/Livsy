//
//  LoginInteractor.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol LoginBusinessLogic {
    func login(request: LoginModels.Login.Request)
    func resetPassword(request: LoginModels.ResetPassword.Request)
}

protocol LoginDataStore {
    var loginSceneDelegate: LoginSceneDelegate? { get set }
    var dismissMode: LoginModels.Mode { get set }
}

final class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    // MARK: - Public Properties
    
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    weak var loginSceneDelegate: LoginSceneDelegate?
    var dismissMode: LoginModels.Mode = .toProfile
    
    // MARK: - Business Logic
    
    func login(request: LoginModels.Login.Request) {
        worker?.login(login: request.username, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            if error == nil {
                UserDefaults.standard.token = response?.token
                UserDefaults.standard.username = response?.userDisplayName
                UserDefaults.standard.password = request.password
            }
            
            self.presenter?.presentLogin(response: LoginModels.Login.Response(error: error, dismissMode: self.dismissMode))
        })
    }
    
    func resetPassword(request: LoginModels.ResetPassword.Request) {
        worker?.resetPassword(login: request.login, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.presenter?.presentResetPassword(response: LoginModels.ResetPassword.Response(result: response?.message ?? "Message sent", error: error))
        })
    }
    
}
