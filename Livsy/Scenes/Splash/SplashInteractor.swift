//
//  SplashInteractor.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol SplashBusinessLogic {
    func login(request: SplashModels.Login.Request)
}

protocol SplashDataStore {
    
}

final class SplashInteractor: SplashBusinessLogic, SplashDataStore {
    
    // MARK: - Public Properties
    
    var presenter: SplashPresentationLogic?
    var worker: SplashWorker?
    
    func login(request: SplashModels.Login.Request) {
        worker?.login(login: request.username, password: request.password, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            if error == nil {
                UserDefaults.standard.token = response?.token
                UserDefaults.standard.username = response?.userDisplayName
                UserDefaults.standard.password = request.password
            } else {
                UserDefaults.standard.token = ""
                UserDefaults.standard.username = ""
                UserDefaults.standard.password = ""
            }
            
            self.presenter?.presentSplash(response: SplashModels.Login.Response(error: error))
        })
    }
    
}
