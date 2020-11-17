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
    func displayPostRemoval(viewModel: ProfileModels.PostToRemove.ViewModel)
    func displayAvatar(viewModel: ProfileModels.Avatar.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Private Properties
    
    private var isLoading = true
    private var isLoggedIn = false
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let greetingsText = "Login or sign up to:"
    private let username = UserDefaults.standard.username
    private let activityIndicator = ActivityIndicator()
    
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
        title = "Profile"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavPosts()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .postListBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.register(MainProfileCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(FavPostsCell.self, forCellReuseIdentifier: "favCellId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func openURL() {
        if let url = URL(string: "https://www.gravatar.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func fetchAvatar() {
        interactor?.getAvatar(request: ProfileModels.Avatar.Request())
    }
    
    private func fetchFavPosts() {
        isLoading = true
        interactor?.showFavPosts(request: ProfileModels.FavoritePosts.Request())
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
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
    
    @objc private func handleAvatarTap() {
        switch UserDefaults.standard.username != "" {
        case true:
            router?.showAvatarQuestionAlert(completion: openURL)
        default:
            break
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
        isLoading = false
        tableView.softReload()
    }
    
    func displayPostRemoval(viewModel: ProfileModels.PostToRemove.ViewModel) {
        tableView.deleteRows(at: [viewModel.indexPath], with: .automatic)
    }
    
    func displayAvatar(viewModel: ProfileModels.Avatar.ViewModel) {
        isLoggedIn ? tableView.reloadWithAnimation() : tableView.softReload()
        isLoggedIn = false
        activityIndicator.hideIndicator()
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
        
        if indexPath.section == 1 {
            routeToPost(id: posts[indexPath.row].id, url: posts[indexPath.row].imgURL ?? "")
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            switch isLoading {
            case true:
                let view = UIView(frame: CGRect(x: self.view.center.x, y: 10, width: 40, height: 40))
                let ai = UIActivityIndicatorView()
                ai.startAnimating()
                ai.center.x = self.view.center.x - 30
                ai.center.y += 10
                view.addSubview(ai)
                return view
            default:
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            return nil
        default:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, sourceView, completionHandler) in
                guard let self = self else { return }
                self.interactor?.removePost(request: ProfileModels.PostToRemove.Request(indexPath: indexPath))
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash.circle.fill")
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let name = UserDefaults.standard.username else { return UITableViewCell() }
        
        var post = Post(id: 0, date: "", title: Title(rendered: "no title"), excerpt: nil, imgURL: "")
        
        let posts = router?.dataStore?.favoritePosts
        if posts?.count ?? 0 > 0 {
            post = posts?[indexPath.row] ?? Post(id: 0, date: "", title: Title(rendered: "no title"), excerpt: nil, imgURL: "")
        }
        
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "favCellId", for: indexPath) as? FavPostsCell else { return UITableViewCell() }
        commentCell.config(post: post)
        
        guard let mainCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MainProfileCell else { return UITableViewCell() }
        
        mainCell.selectionStyle = .none
            
        mainCell.config(mainLabelText: (name == "" ? greetingsText : name), isListHidden: name != "", loginButtonTitle: (name == "" ? "Continue" : "Sign out"))
        
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
