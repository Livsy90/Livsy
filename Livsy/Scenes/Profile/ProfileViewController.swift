//
//  ProfileViewController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: class {
    func displaySignOut()
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Private Properties
    
    private let tableView = UITableView()
    private let greetingsText = "Login or sign up to:"
    
    private let bubbleImage: UIImage = {
        let symbolImage = UIImage(systemName: "captions.bubble.fill")
        return symbolImage ?? UIImage()
    }()
    
    private var avatarImage: UIImage = {
        let symbolImage = UIImage(systemName: "person.circle.fill")
        return symbolImage ?? UIImage()
    }()
    
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
        setupTableView()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.register(MainProfileCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
        
    @objc private func handleLogin() {
        switch UserDefaults.standard.token != "" {
        case true:
            showSignOutQuestion()
        default:
            router?.routeToLogin()
        }
    }
    
}

// MARK: - Profile Display Logic

extension ProfileViewController: ProfileDisplayLogic {
    
    func displaySignOut() {
        router?.showSignOutResultAlert()
        tableView.reloadData()
    }
    
}

extension ProfileViewController: LoginSceneDelegate {
    
    func setupUIforLoggedIn() {
        tableView.reloadData()
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
          return ""
        default:
          return UserDefaults.standard.token == "" ? "" : "Comments"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let text = UserDefaults.standard.username else { return UITableViewCell() }
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell1.textLabel?.text  = "  J!"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MainProfileCell
        cell.selectionStyle = .none
        cell.config(mainImage: (text == "" ? bubbleImage : avatarImage), mainLabelText: (text == "" ? greetingsText : text), isListHidden: text != "", loginButtonTitle: (text == "" ? "Continue" : "Sign out"))
        cell.loginCompletion = { [weak self] in
        guard let self = self else { return }
            self.handleLogin()
        }
        switch indexPath.section {
        case 0:
            return cell
        default:
            return cell1
        }
    }
    
    
}
