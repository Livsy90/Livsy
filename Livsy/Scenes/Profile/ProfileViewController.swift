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
    func displayUserComments(viewModel: ProfileModels.UserComments.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Private Properties
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let greetingsText = "Login or sign up to:"
    private let username = UserDefaults.standard.username
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserComments()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.register(MainProfileCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func fetchUserComments() {
        UserDefaults.standard.token == "" ? tableView.softReload() : interactor?.showComments(request: ProfileModels.UserComments.Request())
    }
    
    private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    @objc private func handleLogin() {
        switch UserDefaults.standard.username != "" {
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
        tableView.reloadWithAnimation()
    }
    
    func displayUserComments(viewModel: ProfileModels.UserComments.ViewModel) {
        tableView.softReload()
    }
    
}

extension ProfileViewController: LoginSceneDelegate {
    
    func setupUIforLoggedIn() {
        tableView.reloadWithAnimation()
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return UserDefaults.standard.token == "" ? 0 : router?.dataStore?.comments.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let token = UserDefaults.standard.token
        switch section {
        case 0:
            return ""
        default:
            return token == "" ? "" : "Comments"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let name = UserDefaults.standard.username else { return UITableViewCell() }
        
        var comment = PostComment(id: 0, parent: 0, authorName: "Livsy")
        
        let comments = router?.dataStore?.comments
        if comments?.count ?? 0 > 0 {
            comment = comments?[indexPath.row] ?? PostComment(id: 0, parent: 0, authorName: "Livsy")
            
        }
        
        
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier(), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        
        commentCell.config(comment: comment, isReplyButtonHidden: true)
        
        guard let mainCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MainProfileCell else { return UITableViewCell() }
        mainCell.selectionStyle = .none
        mainCell.config(mainImage: (name == "" ? bubbleImage : avatarImage), mainLabelText: (name == "" ? greetingsText : name), isListHidden: name != "", loginButtonTitle: (name == "" ? "Continue" : "Sign out"))
        mainCell.loginCompletion = { [weak self] in
            guard let self = self else { return }
            self.handleLogin()
        }
        
        switch indexPath.section {
        case 0:
            return mainCell
        default:
            return commentCell
        }
    }
    
    
}
