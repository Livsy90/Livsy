//
//  RegisterConfigurator.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class RegisterConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = RegisterConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: RegisterViewController) {
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let router = RegisterRouter()
        let worker = RegisterWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
