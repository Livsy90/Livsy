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
}

protocol ProfileDataStore {
  
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

  // MARK: - Public Properties

  var presenter: ProfilePresentationLogic?
  lazy var worker: ProfileWorkingLogic = ProfileWorker()

  // MARK: - Private Properties
  
  // MARK: - Data Store

  // MARK: - Business Logic
    
    func signOut() {
        UserDefaults.standard.token = ""
        UserDefaults.standard.username = ""
        UserDefaults.standard.password = ""
        presenter?.presentSignOut()
    }
}
