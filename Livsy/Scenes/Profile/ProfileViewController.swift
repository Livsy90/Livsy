//
//  ProfileViewController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: class {
  
}

final class ProfileViewController: UIViewController {

  // MARK: - IBOutlets
  
  // MARK: - Public Properties

  var interactor: ProfileBusinessLogic?
  var router: (ProfileRoutingLogic & ProfileDataPassing)?

  // MARK: - Private Properties

  // MARK: - Initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    ProfileConfigurator.sharedInstance.configure(viewController: self)
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Private Methods
  
  // MARK: - Requests

  // MARK: - IBActions

}

// MARK: - Profile Display Logic
extension ProfileViewController: ProfileDisplayLogic {
  
}
