//
//  SignUpInteractor.swift
//  Livsy
//
//  Created by Artem on 01.08.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol SignUpBusinessLogic {
  
}

protocol SignUpDataStore {
  
}

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {

  // MARK: - Public Properties

  var presenter: SignUpPresentationLogic?
  var worker: SignUpWorker?
    
  // MARK: - Private Properties
  
  // MARK: - Data Store

  // MARK: - Business Logic
}
