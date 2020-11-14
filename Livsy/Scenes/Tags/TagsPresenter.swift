//
//  TagsPresenter.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol TagsPresentationLogic {
    func presentTags(response: TagsModels.Tags.Response)
}

final class TagsPresenter: TagsPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: TagsDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    func presentTags(response: TagsModels.Tags.Response) {
        viewController?.displayTags(viewModel: TagsModels.Tags.ViewModel())
    }
    
}
