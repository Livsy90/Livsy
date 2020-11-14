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
    func displayToken(viewModel: PostListModels.Login.ViewModel)
    func displaySignOut()
    func displayTags(viewModel: PostListModels.Tags.ViewModel)
}

final class PostListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PostListBusinessLogic?
    var router: (PostListRoutingLogic & PostListDataPassing)?
    
    // MARK: - Private Properties
    
    private var nothingFoundImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 150, weight: .bold, scale: .large)
        let image = UIImage(systemName: "doc.text.magnifyingglass", withConfiguration: config)
        let v = UIImageView(image: image)
        v.tintColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        v.isHidden = true
        return v
    }()
     let tagsButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .medium)
        let listImage = UIImage(systemName: "list.bullet", withConfiguration: config)
        button.setImage(listImage, for: .normal)
        button.setImage(listImage, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showTags), for: .touchUpInside)
        return button
    }()
    private let activityIndicator = ActivityIndicator()
    private let searchController = UISearchController(searchResultsController: nil)
    private var refreshControl: UIRefreshControl!
    private var postCollectionView = PostListCollectionView()
    private var page = 0
    private var searchTerms = ""
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Livsy"
        checkToken()
        setupCollectionView()
        setupRefreshControl()
        fetchPostList(isLoadMore: false)
        setupTagsButton()
        fetchTagList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Private Methods
    
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
        
        postCollectionView.addSubview(nothingFoundImageView)
        nothingFoundImageView.centerYAnchor.constraint(equalTo: postCollectionView.centerYAnchor, constant: -50).isActive = true
        nothingFoundImageView.centerXAnchor.constraint(equalTo: postCollectionView.centerXAnchor).isActive = true
        
    }
    
    private func setupNavBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
    }
    
    private func checkToken() {
        interactor?.login(request: PostListModels.Login.Request(username: UserDefaults.standard.username ?? "" , password: UserDefaults.standard.password ?? ""))
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
        interactor?.fetchPostList(request: PostListModels.PostList.Request(page: page, searchTerms: searchTerms))
    }
    
    private func fetchTagList() {
        tagsButton.isEnabled = false
        interactor?.fetchTags(request: PostListModels.Tags.Request())
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func setupTagsButton() {
        view.addSubview(tagsButton)
        tagsButton.tintColor = .gray
        tagsButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 45, paddingRight: 12, width: 48, height: 48)
        tagsButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        tagsButton.layer.cornerRadius = 12
        tagsButton.layer.shadowRadius = 2
        tagsButton.layer.shadowOpacity = 0.2
        tagsButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc private func refreshData() {
        page = 0
        searchTerms = ""
        fetchPostList(isLoadMore: false)
        fetchTagList()
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    @objc private func search() {
        interactor?.search(request: PostListModels.PostList.Request(page: 1))
    }
    
    @objc private func showTags() {
        tagsButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.router?.routeTags()
        }
        
    }
    
}

// MARK: - PostList Display Logic

extension PostListViewController: PostListDisplayLogic {
    func displayPostList(viewModel: PostListModels.PostList.ViewModel) {
        guard let posts = router?.dataStore?.postList else { return }
        postCollectionView.isStopRefreshing = viewModel.isStopRereshing
        postCollectionView.set(cells: posts)
        postCollectionView.softReload()
        refreshControl.endRefreshing()
        postCollectionView.footerView.stopAnimating()
        nothingFoundImageView.isHidden = !posts.isEmpty
        activityIndicator.hideIndicator()
    }
    
    func displayToken(viewModel: PostListModels.Login.ViewModel) {
        
    }
    
    func displaySignOut() {
        router?.showSignOutResultAlert()
    }
    
    func displayTags(viewModel: PostListModels.Tags.ViewModel) {
        tagsButton.isEnabled = true
    }
    
}

extension PostListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerms = searchBar.text ?? ""
        page = 0
        fetchPostList(isLoadMore: false)
        activityIndicator.showIndicator(on: self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        refreshData()
        activityIndicator.showIndicator(on: self)
    }
    
}

extension PostListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarUpdateAnimation
        }
        
        return .slide // .fade, .none
    }
}

