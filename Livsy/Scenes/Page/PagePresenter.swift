//
//  PagePresenter.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PagePresentationLogic {
    func presentPage(response: PageModels.Page.Response)
}

final class PagePresenter: PagePresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PageDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentPage(response: PageModels.Page.Response) {
        viewController?.displayPage(viewModel: PageModels.Page.ViewModel())
    }
}
