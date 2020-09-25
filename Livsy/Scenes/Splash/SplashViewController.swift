//
//  SplashViewController.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol SplashDisplayLogic: class {
    func displaySplash(viewModel: SplashModels.Login.ViewModel)
}

final class SplashViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: SplashBusinessLogic?
    var router: (SplashRoutingLogic & SplashDataPassing)?
    
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
        SplashConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func checkToken() {
        interactor?.login(request: SplashModels.Login.Request(username: UserDefaults.standard.username ?? "" , password: UserDefaults.standard.password ?? ""))
    }
    
}

// MARK: - Splash Display Logic
extension SplashViewController: SplashDisplayLogic {
    
    func displaySplash(viewModel: SplashModels.Login.ViewModel) {
        router?.routeToPostList()
    }
    
}
