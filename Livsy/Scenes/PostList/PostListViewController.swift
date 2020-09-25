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
        PostListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        setupNavigationBar()
        fetchPostList()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = "Livsy.me"
        if UserDefaults.standard.token == "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(routeToLogin))
        }
        
    }
    
    private func setupCollectionView() {
        view.addSubview(postCollectionView)
        
        postCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postCollectionView.fetchIdCompletion = { [weak self] (id) in
            guard let self = self else { return }
            self.routeToPost(with: id)
        }
        
        postCollectionView.loadMoreCompletion = { [weak self] in
            guard let self = self else { return }
            self.fetchPostList()
        }
    }
    
    private func routeToPost(with id: Int) {
        router?.routeToPost(with: id)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        postCollectionView.addSubview(refreshControl)
    }
    
    @objc private func refreshData() {
        page = 0
        fetchPostList()
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    private func fetchPostList() {
        activityIndicator.showIndicator(on: self)
        page += 1
        interactor?.fetchPostList(request: PostListModels.PostList.Request(page: page))
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
        activityIndicator.hideIndicator()
    }
    
}
