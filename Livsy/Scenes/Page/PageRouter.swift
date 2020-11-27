//
//  PageRouter.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PageRoutingLogic {
  
}

protocol PageDataPassing {
  var dataStore: PageDataStore? { get }
}

final class PageRouter: PageRoutingLogic, PageDataPassing {

  // MARK: - Public Properties

  weak var viewController: PageViewController?
  var dataStore: PageDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
