//
//  PageListRouter.swift
//  Livsy
//
//  Created by Artem on 26.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PageListRoutingLogic {
  
}

protocol PageListDataPassing {
  var dataStore: PageListDataStore? { get }
}

final class PageListRouter: PageListRoutingLogic, PageListDataPassing {

  // MARK: - Public Properties

  weak var viewController: PageListViewController?
  var dataStore: PageListDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
