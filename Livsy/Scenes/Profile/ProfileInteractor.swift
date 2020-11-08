//
//  ProfileInteractor.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol ProfileBusinessLogic {
    func signOut()
    func showComments(request: ProfileModels.UserComments.Request)
}

protocol ProfileDataStore {
    var comments: [PostComment] { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    
    // MARK: - Public Properties
    
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var comments: [PostComment] = []
    
    // MARK: - Business Logic
    
    func signOut() {
        UserDefaults.standard.token = ""
        UserDefaults.standard.username = ""
        UserDefaults.standard.password = ""
        presenter?.presentSignOut()
    }
    
    func showComments(request: ProfileModels.UserComments.Request) {
        worker?.fetchUserComments(completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.comments = response ?? []
            self.presenter?.presentUserComments(response: ProfileModels.UserComments.Response())
        })
    }
}
