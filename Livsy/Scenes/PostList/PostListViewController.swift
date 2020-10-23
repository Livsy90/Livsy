//
//  PostListViewController.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostListDisplayLogic: class {
    func displayPostList(viewModel: PostListModels.PostList.ViewModel)
    func displaySignOut()
}

final class PostListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PostListBusinessLogic?
    var router: (PostListRoutingLogic & PostListDataPassing)?
    
    // MARK: - Private Properties
    private var refreshControl: UIRefreshControl!
    private var postCollectionView = PostListCollectionView()
    private var page = 0
    private var isLoadMore = false
    
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
        PostListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        fetchPostList(isLoadMore: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = "Livsy.me"
        if UserDefaults.standard.token == "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(routeToLogin))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(showSignOutQuestion))
        }
        
    }
    
    private func setupCollectionView() {
        view.addSubview(postCollectionView)
        postCollectionView.footerView.startAnimating()
        postCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postCollectionView.fetchIdCompletion = { [weak self] (id, url) in
            guard let self = self else { return }
            self.routeToPost(id: id, url: url)
        }
        
        postCollectionView.loadMoreCompletion = { [weak self] isLoadMore in
            guard let self = self else { return }
            self.fetchPostList(isLoadMore: isLoadMore)
        }
        
    }
    
    private func routeToPost(id: Int, url: String) {
        router?.routeToPost(id: id, url: url)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        postCollectionView.addSubview(refreshControl)
    }
    
    private func fetchPostList(isLoadMore: Bool) {
        page += 1
        isLoadMore ? postCollectionView.footerView.startAnimating() : {}()
        interactor?.fetchPostList(request: PostListModels.PostList.Request(page: page))
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    @objc private func refreshData() {
        page = 0
        fetchPostList(isLoadMore: false)
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    // MARK: - Requests
    
    // MARK: - IBActions
    
}

// MARK: - PostList Display Logic
extension PostListViewController: PostListDisplayLogic {
    func displayPostList(viewModel: PostListModels.PostList.ViewModel) {
        guard let posts = router?.dataStore?.postList else { return }
        postCollectionView.isStopRefreshing = viewModel.isStopRereshing
        postCollectionView.set(cells: posts)
        postCollectionView.reloadData()
        refreshControl.endRefreshing()
        postCollectionView.footerView.stopAnimating()
    }
    
    func displaySignOut() {
        setupNavigationBar()
        router?.showSignOutResultAlert()
    }
    
}
