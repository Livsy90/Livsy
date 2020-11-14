//
//  TagsInteractor.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol TagsBusinessLogic {
    func fetchTags(request: TagsModels.Tags.Request)
}

protocol TagsDataStore {
    var tags: [Tag] { get set }
}

final class TagsInteractor: TagsBusinessLogic, TagsDataStore {
    var tags: [Tag] = []
    
    
    // MARK: - Public Properties
    
    var presenter: TagsPresentationLogic?
    lazy var worker: TagsWorkingLogic = TagsWorker()
    
    func fetchTags(request: TagsModels.Tags.Request) {
        worker.fetchTags { [weak self] (response, error) in
            guard let self = self else { return }
            self.tags = response ?? []
            
            self.presenter?.presentTags(response: TagsModels.Tags.Response())
            
        }
    }
}
