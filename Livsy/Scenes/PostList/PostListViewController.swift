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
    func displayPostListByCategory(viewModel: PostListModels.FilteredPostList.ViewModel)
}

final class PostListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PostListBusinessLogic?
    var router: (PostListRoutingLogic & PostListDataPassing)?
    
    var tagsButton = UIButton()
    var categoriesButton = UIButton()

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
    
    private var homeButton = UIButton()

    private let activityIndicator = ActivityIndicator()
    private let searchController = UISearchController(searchResultsController: nil)
    private var refreshControl: UIRefreshControl!
    private var postCollectionView = PostListCollectionView()
    private var page = 0
    private var searchTerms = ""
    private var isLoadMore = false
    private var byCategory: Bool = false
    private var byTag: Bool = false
    private var filterId: Int?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        setupNavBar()
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
            
            if self.byCategory {
                self.fetchFilteredPostList(isLoadMore: isLoadMore, id: self.filterId ?? 00, isTag: self.byCategory)
            } else if self.byTag {
                self.fetchFilteredPostList(isLoadMore: isLoadMore, id: self.filterId ?? 00, isTag: self.byTag)
            } else {
                self.fetchPostList(isLoadMore: isLoadMore)
            }
            
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
        
//
//        self.navigationItem.titleView = activityIndicator
//        activityIndicator.startAnimating()
        let tagsBotton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        let tagImage = UIImage(systemName: "tag.fill", withConfiguration: config)
        tagsBotton.setImage(tagImage, for: .normal)
        tagsBotton.addTarget(self, action: #selector(showTags), for: .touchUpInside)
        tagsButton = tagsBotton
        
        let catButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let listImage = UIImage(systemName: "list.bullet", withConfiguration: config)
        catButton.setImage(listImage, for: .normal)
        catButton.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        categoriesButton = catButton
        
        let hButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let homeImage = UIImage(systemName: "house.fill", withConfiguration: config)
        hButton.setImage(homeImage, for: .normal)
        hButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        homeButton = hButton
        
        if byTag || byCategory {
            homeButton.alpha = 1
        } else {
            homeButton.alpha = 0
        }
        
        let leftItem =  UIBarButtonItem(customView: categoriesButton)
        let homeItem =  UIBarButtonItem(customView: homeButton)
        navigationItem.leftBarButtonItems = [leftItem, homeItem]
        let rightItem =  UIBarButtonItem(customView: tagsButton)
        navigationItem.rightBarButtonItem = rightItem
        
        fetchTagList(isTags: true)
        fetchTagList(isTags: false)
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
        homeButton.isEnabled = false
        categoriesButton.isEnabled = false
        tagsButton.isEnabled = false
        byCategory = false
        byTag = false
        page += 1
        isLoadMore ? postCollectionView.footerView.startAnimating() : {}()
        interactor?.fetchPostList(request: PostListModels.PostList.Request(page: page, searchTerms: searchTerms))
    }
    
    private func fetchFilteredPostList(isLoadMore: Bool, id: Int, isTag: Bool) {
        page += 1
        isLoadMore ? postCollectionView.footerView.startAnimating() : {}()
        interactor?.fetchFilteredPostList(request: PostListModels.FilteredPostList.Request(isTag: isTag, page: page, id: id))
    }
    
    private func fetchTagList(isTags: Bool) {
        interactor?.fetchTags(request: PostListModels.Tags.Request(isTags: isTags))
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    @objc private func refreshData() {
        activityIndicator.showIndicator(on: self)
        page = 0
        searchTerms = ""
        byCategory = false
        byTag = false
        fetchPostList(isLoadMore: false)
        fetchTagList(isTags: true)
        fetchTagList(isTags: false)
        title = "Livsy"
        UIView.animate(withDuration: 0.3, animations: {
            self.homeButton.alpha = 0
        })
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
            self.postCollectionView.isUserInteractionEnabled.toggle()
        }
    }
    
    @objc func showCategories() {
        categoriesButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.router?.routeCategories()
            self.postCollectionView.isUserInteractionEnabled.toggle()
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

    }
    
    func displayPostListByCategory(viewModel: PostListModels.FilteredPostList.ViewModel) {
        guard let posts = router?.dataStore?.postList else { return }
        postCollectionView.isStopRefreshing = viewModel.isStopRereshing
        postCollectionView.set(cells: posts)
        postCollectionView.softReload()
        refreshControl.endRefreshing()
        postCollectionView.footerView.stopAnimating()
        nothingFoundImageView.isHidden = !posts.isEmpty
        activityIndicator.hideIndicator()
        
        if byCategory || byTag {
            UIView.animate(withDuration: 0.2, animations: {
                self.homeButton.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.homeButton.alpha = 0
            })
        }
        
        homeButton.isEnabled = true
        categoriesButton.isEnabled = true
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

extension PostListViewController: CategoriesViewControllerDelegate {
    
    func fetchPostListByCategory(id: Int) {
        activityIndicator.showIndicator(on: self)
        byCategory = true
        byTag = false
        page = 0
        filterId = id
        fetchFilteredPostList(isLoadMore: false, id: id, isTag: false)
        title = router?.dataStore?.categories.first { $0.id == id }?.name
    }
    
}

extension PostListViewController: TagsViewControllerDelegate {
    
    func fetchPostListByTag(id: Int) {
        activityIndicator.showIndicator(on: self)
        byTag = true
        byCategory = false
        page = 0
        filterId = id
        fetchFilteredPostList(isLoadMore: false, id: id, isTag: true)
        title = router?.dataStore?.tags.first { $0.id == id }?.name
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

