//
//  SplashConfigurator.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class SplashConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = SplashConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: SplashViewController) {
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
        let worker = SplashWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
