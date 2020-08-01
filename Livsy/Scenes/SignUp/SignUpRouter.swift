//
//  SignUpRouter.swift
//  Livsy
//
//  Created by Artem on 01.08.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol SignUpRoutingLogic {
  
}

protocol SignUpDataPassing {
  var dataStore: SignUpDataStore? { get }
}

final class SignUpRouter: SignUpRoutingLogic, SignUpDataPassing {

  // MARK: - Public Properties

  weak var viewController: SignUpViewController?
  var dataStore: SignUpDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
