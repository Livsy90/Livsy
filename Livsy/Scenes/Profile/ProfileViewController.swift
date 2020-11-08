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
    func displayFavPosts(viewModel: ProfileModels.FavoritePosts.ViewModel)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavPosts()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func fetchFavPosts() {
        interactor?.showFavPosts(request: ProfileModels.FavoritePosts.Request())
    }
    
    private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    private func routeToPost(id: Int, url: String) {
        router?.routeToPost(id: id, url: url)
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
    
    func displayFavPosts(viewModel: ProfileModels.FavoritePosts.ViewModel) {
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
        let posts = router?.dataStore?.favoritePosts ?? []
        tableView.deselectRow(at: indexPath, animated: true)
        routeToPost(id: posts[indexPath.row].id, url: posts[indexPath.row].imgURL ?? "")
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return router?.dataStore?.favoritePosts.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let posts = router?.dataStore?.favoritePosts ?? []
        switch section {
        case 0:
            return ""
        default:
            return posts.count == 0 ? "No favorite posts yet" : "Favorite posts"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let name = UserDefaults.standard.username else { return UITableViewCell() }
        
        var comment = Post(id: 0, date: "", title: Title(rendered: "Hi"), excerpt: nil, imgURL: "")
        
        let comments = router?.dataStore?.favoritePosts
        if comments?.count ?? 0 > 0 {
            comment = comments?[indexPath.row] ?? Post(id: 0, date: "", title: Title(rendered: "Hi"), excerpt: nil, imgURL: "")
            
        }
        
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        commentCell.textLabel?.text = comment.title?.rendered
        
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
