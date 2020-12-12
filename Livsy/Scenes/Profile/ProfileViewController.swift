//
//  ProfileViewController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit
import MessageUI

protocol ProfileDisplayLogic: class {
    func displaySignOut()
    func displayFavPosts(viewModel: ProfileModels.FavoritePosts.ViewModel)
    func displayPostRemoval(viewModel: ProfileModels.PostToRemove.ViewModel)
    func displayAvatar(viewModel: ProfileModels.Avatar.ViewModel)
    func displayPost(viewModel: ProfileModels.PostPage.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Private Properties
    
    private var isLoading = true
    private var isLoggedIn = false
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let greetingsText = Text.Profile.loginOrSignUp
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
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        let worker = ProfileWorker()
        
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Text.Profile.profile
        setupTableView()
        setupMailButton()
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
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemUltraThinMaterial))
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
    
    private func setupMailButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Text.Profile.feedback, style: .plain, target: self, action: #selector(presentMailViewController))
    }
    
    private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    private func routeToPost(id: Int, url: String) {
        
    }
    
    private func getAppVersion() -> String {
        guard
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        else { return "" }
        
        return "\(version) (\(build))"
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
    
    @objc private func presentMailViewController() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Text.Profile.supportEmail])
            let appVersion = getAppVersion()
            mail.setSubject("\(Text.Profile.feedbackSubject) \(appVersion)")
            mail.modalPresentationStyle = .automatic
            present(mail, animated: true)
        } else {
            showAlertWithOneButton(title: Text.Profile.noMailAccount, message: nil, buttonTitle: Text.Common.ok, buttonAction: nil)
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
    
    func displayPost(viewModel: ProfileModels.PostPage.ViewModel) {
        router?.routeToPost()
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
        
        if indexPath.section == 1 {
            let posts = router?.dataStore?.favoritePosts ?? []
            interactor?.showPost(request: ProfileModels.PostPage.Request(post: posts[indexPath.row]))
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
                let ai = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: 10, width: 40, height: 40))
                ai.startAnimating()
                ai.center.x = view.center.x
                ai.center.y += 10
                return ai
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
            return posts.count == 0 ? Text.Profile.noFavPosts : Text.Profile.favPosts
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
            deleteAction.image = UIImage(systemName: "xmark.circle.fill")
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let name = UserDefaults.standard.username else { return UITableViewCell() }
        
        var post = Post(id: 0, date: "", title: Title(rendered: "no title"), excerpt: nil, imgURL: "", link: "", content: nil, author: 00)
        
        let posts = router?.dataStore?.favoritePosts
        if posts?.count ?? 0 > 0 {
            post = posts?[indexPath.row] ?? post
        }
        
        guard let favCell = tableView.dequeueReusableCell(withIdentifier: "favCellId", for: indexPath) as? FavPostsCell else { return UITableViewCell() }
        favCell.config(post: post)
        favCell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        
        guard let mainCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MainProfileCell else { return UITableViewCell() }
        
        mainCell.selectionStyle = .none
        
        mainCell.config(mainLabelText: (name == "" ? greetingsText : name), isListHidden: name != "", loginButtonTitle: (name == "" ? Text.Profile.continueToLogin : Text.Profile.signOut))
        
        mainCell.loginCompletion = { [weak self] in
            guard let self = self else { return }
            self.handleLogin()
        }
        
        switch indexPath.section {
        case 0:
            return mainCell
        default:
            return favCell
        }
    }
    
}

// MARK: - MFMailComposeViewController Delegate
extension ProfileViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled, .saved, .failed:
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            controller.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.showAlertWithOneButton(title: Text.Profile.emailSent, message: nil, buttonTitle: Text.Common.ok, buttonAction: nil)
            }
        @unknown default:
            break
        }
    }
    
}

extension ProfileViewController: TabBarReselectHandling {
    
    func handleReselect() {
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .middle, animated: true)
    }
    
}
