//
//  PageListInteractor.swift
//  Livsy
//
//  Created by Artem on 26.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PageListBusinessLogic {
}

protocol PageListDataStore {
    var pageList: [Post] { get set }
    
}

final class PageListInteractor: PageListBusinessLogic, PageListDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PageListPresentationLogic?
    lazy var worker: PageListWorkingLogic = PageListWorker()
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var pageList: [Post] = []
    
    // MARK: - Business Logic

}
