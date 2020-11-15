//
//  CategoriesInteractor.swift
//  Livsy
//
//  Created by Artem on 15.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol CategoriesBusinessLogic {
    
}

protocol CategoriesDataStore {
    var categories: [Tag] { get set }
}

final class CategoriesInteractor: CategoriesBusinessLogic, CategoriesDataStore {
    
    // MARK: - Public Properties
    
    var presenter: CategoriesPresentationLogic?
    lazy var worker: CategoriesWorkingLogic = CategoriesWorker()
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var categories: [Tag]  = []
    
    // MARK: - Business Logic
}
