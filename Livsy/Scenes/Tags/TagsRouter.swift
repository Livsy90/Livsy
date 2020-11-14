//
//  TagsRouter.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol TagsRoutingLogic {
  
}

protocol TagsDataPassing {
  var dataStore: TagsDataStore? { get }
}

final class TagsRouter: TagsRoutingLogic, TagsDataPassing {

  // MARK: - Public Properties

  weak var viewController: TagsViewController?
  var dataStore: TagsDataStore?
  
  // MARK: - Private Properties

  // MARK: - Routing Logic

  // MARK: - Navigation

  // MARK: - Passing data
}
