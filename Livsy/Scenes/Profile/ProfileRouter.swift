//
//  ProfileRouter.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfileRoutingLogic {
  
}

protocol ProfileDataPassing {
  var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: ProfileRoutingLogic, ProfileDataPassing {

  // MARK: - Public Properties

  weak var viewController: ProfileViewController?
  var dataStore: ProfileDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
