//
//  SignUpViewController.swift
//  Livsy
//
//  Created by Artem on 01.08.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: class {
  
}

final class SignUpViewController: UIViewController {

  // MARK: - IBOutlets
  
  // MARK: - Public Properties

  var interactor: SignUpBusinessLogic?
  var router: (SignUpRoutingLogic & SignUpDataPassing)?

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
    let interactor = SignUpInteractor()
    let presenter = SignUpPresenter()
    let router = SignUpRouter()

    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.dataStore = interactor

    self.interactor = interactor
    self.router = router
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Private Methods
  
  // MARK: - Requests

  // MARK: - IBActions

}

// MARK: - SignUp Display Logic
extension SignUpViewController: SignUpDisplayLogic {
  
}
