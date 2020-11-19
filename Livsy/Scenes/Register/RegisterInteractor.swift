//
//  RegisterInteractor.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol RegisterBusinessLogic {
    func register(request: RegisterModels.Register.Request)
    func login(request: RegisterModels.Login.Request)
}

protocol RegisterDataStore {
    
}

final class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore {
    
    // MARK: - Public Properties
    
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorker?
    
    func register(request: RegisterModels.Register.Request) {
        worker?.register(username: request.username, email: request.email, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.presenter?.presentRegister(response: RegisterModels.Register.Response(error: error))
            
        })
    }
    
    func login(request: RegisterModels.Login.Request) {
        worker?.login(login: request.username, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            if error == nil {
                UserDefaults.standard.token = response?.token
                UserDefaults.standard.username = response?.userDisplayName
                UserDefaults.standard.password = request.password
            }
            
            self.presenter?.presentLogin(response: RegisterModels.Login.Response(error: error, username: request.username, password: request.password))
        })
    }
    
}
