//
//  ProfileConfigurator.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class ProfileConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = ProfileConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: ProfileViewController) {
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        let worker = ProfileWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
