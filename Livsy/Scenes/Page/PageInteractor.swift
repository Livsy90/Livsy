//
//  PageInteractor.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PageBusinessLogic {
    func fetchpage(request: PageListModels.Page.Request)
}

protocol PageDataStore {
    var title: String? { get set }
    var content: String? { get set }
    var id: Int { get set }
    
}

final class PageInteractor: PageBusinessLogic, PageDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PagePresentationLogic?
    lazy var worker: PageWorkingLogic = PageWorker()
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    var title: String? = ""
    var content: String? = ""
    var id: Int = 1
    // MARK: - Business Logic
    
    func fetchpage(request: PageListModels.Page.Request) {
        worker.fetchPage(id: id) { [weak self] (response, error) in
            guard let self = self else { return }
            self.title = response?.title?.rendered.pureString()
            self.content = response?.content?.rendered
            self.presenter?.presentPage(response: PageModels.Page.Response())
        }
    }
}
