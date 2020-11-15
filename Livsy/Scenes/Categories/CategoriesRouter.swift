//
//  CategoriesRouter.swift
//  Livsy
//
//  Created by Artem on 15.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol CategoriesRoutingLogic {
  
}

protocol CategoriesDataPassing {
  var dataStore: CategoriesDataStore? { get }
}

final class CategoriesRouter: CategoriesRoutingLogic, CategoriesDataPassing {

  // MARK: - Public Properties

  weak var viewController: CategoriesViewController?
  var dataStore: CategoriesDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
