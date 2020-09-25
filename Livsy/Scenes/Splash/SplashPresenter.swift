//
//  SplashPresenter.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol SplashPresentationLogic {
    func presentSplash(response: SplashModels.Login.Response)
}

final class SplashPresenter: SplashPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: SplashDisplayLogic?
    
    func presentSplash(response: SplashModels.Login.Response) {
        viewController?.displaySplash(viewModel: SplashModels.Login.ViewModel(error: response.error))
    }
    
    
}
