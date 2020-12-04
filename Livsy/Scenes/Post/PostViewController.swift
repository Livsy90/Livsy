//
//  PostViewController.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import StoreKit
import UIKit

protocol PostDisplayLogic: class {
    func displayPostPage(viewModel: PostModels.PostPage.ViewModel)
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel)
    func displayFavorites(viewModel: PostModels.SaveToFavorites.ViewModel)
    func displayAuthorName(viewModel: PostModels.AuthorName.ViewModel)
    func displayUI(viewModel: PostModels.Color.ViewModel)
}

final class PostViewController: UIViewController {
    // MARK: - Public Properties
    
    var interactor: PostBusinessLogic?
    var router: (PostRoutingLogic & PostDataPassing)?
    
    var shareButton = UIButton()
    
    // MARK: - Private Properties
    
    private var id = 0
    private let activityIndicator = ActivityIndicator()
    private let loadingCommentsIndicator = UIActivityIndicatorView()
    private let textView = CustomTextView()
    private let scrollView = UIScrollView()
    private let postTitleLabel = UILabel()
    private let imageView = WebImageView()
    private let lblName = UILabel()
    private var favButton = UIButton()
    private var commentsButtonItem = UIBarButtonItem()
    private let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    private var isShowReviewAlert: Bool {
        let addPostOpenCount = UserDefaults.standard.addPostOpenCount
        
        switch addPostOpenCount {
        case 10, 20, 30:
            incrementPostOpenCount()
            return true
        default:
            return false
        }
    }
    
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
        let interactor = PostInteractor()
        let presenter = PostPresenter()
        let router = PostRouter()
        let worker = PostWorker()
        
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavImage(isFavorite: UserDefaults.favPosts?.contains(router?.dataStore?.post.id ?? 00) ?? false, animated: false)
        fetchPostComments()
        setupNavBar()
        incrementOpenPostCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupProgressView()
        showReviewAlert()
    }
    
    // MARK: - Private Methods
    
    private func setupHeader() {
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = router?.dataStore?.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        darkView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.addSubview(darkView)
        postTitleSetup()
        postTitleLabel.frame = CGRect(x: 20, y: 400, width: UIScreen.main.bounds.width - 40, height: 200)
        postTitleLabel.font = UIFont.systemFont(ofSize: 26)
        postTitleLabel.clipsToBounds = true
        imageView.addSubview(postTitleLabel)
    }
    
    private func setupUI() {
        view.backgroundColor = .postBackground
        interactor?.getAverageColorAndSetupUI(request: PostModels.Color.Request())
    }
    
    private func incrementPostOpenCount() {
        var addPostOpenCount = UserDefaults.standard.addPostOpenCount ?? 0
        guard addPostOpenCount < 31 else { return }
        addPostOpenCount += 1
        UserDefaults.standard.addPostOpenCount = addPostOpenCount
    }
    
    private func setupNavBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        guard let color = router?.dataStore?.averageColor else { return }
        let cgColor1 = color.cgColor
        let cgColor2 = color.withAlphaComponent(0.3).cgColor
        let cgColor3 = color.withAlphaComponent(0.1).cgColor
        gradientLayer.colors = [cgColor1, cgColor2, cgColor3, cgColor3, cgColor2]
        self.view.layer.addSublayer(gradientLayer)
    }
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 150, left: 20, bottom: 0, right: 20)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: self.topbarHeight - 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        let color = router?.dataStore?.averageColor ?? .blueButton
        progressView.progressTintColor = color
    }
    
    func incrementOpenPostCount() {
        var addPostOpenCount = UserDefaults.standard.addPostOpenCount ?? 0
        guard addPostOpenCount < 21 else { return }
        addPostOpenCount += 1
        UserDefaults.standard.addPostOpenCount = addPostOpenCount
    }
    
    private func showReviewAlert() {
        if isShowReviewAlert {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func postTitleSetup() {
        postTitleLabel.textColor = .white
        postTitleLabel.lineBreakMode = .byWordWrapping
        postTitleLabel.numberOfLines = 0
    }
    
    @objc private func share() {
        router?.sharePost()
    }
    
    private func textViewSetup() {
        textView.backgroundColor = .clear
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        textView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .commentBody
        textView.textAlignment = .left
        textView.tintColor = router?.dataStore?.averageColor ?? .blue
        textView.alpha = 0
    }
    
    private func showActivityIndicatorOnNavBarItem() {
        loadingCommentsIndicator.color = .white
        loadingCommentsIndicator.hidesWhenStopped = true
        loadingCommentsIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingCommentsIndicator)
    }
    
    private func rightNavItemsSetup() {
        loadingCommentsIndicator.stopAnimating()
        let count = router?.dataStore?.comments.count ?? 0
        let postAuthorName = router?.dataStore?.authorName ?? ""
        let countLabelText = count == 0 ? Text.Post.comments : "\(Text.Post.comments): \(count)"
        let commentsItem = UIBarButtonItem(title: countLabelText, style: .done, target: self, action: #selector(routeToComments))
        commentsButtonItem = commentsItem
        commentsButtonItem.isEnabled = !postAuthorName.isEmpty
        
        let flameButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        flameButton.addTarget(self, action: #selector(savePostToFav), for: .touchUpInside)
        favButton = flameButton
        let favItem =  UIBarButtonItem(customView: favButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .medium)
        let shareImage = UIImage(systemName: "arrowshape.turn.up.right", withConfiguration: config)
        
        let shareButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        shareButton.setImage(shareImage, for: .normal)
        self.shareButton = shareButton
        let shareItem =  UIBarButtonItem(customView: self.shareButton)
        
        
        let id = router?.dataStore?.post.id
        let array = UserDefaults.favPosts ?? []
        let isFavorite = array.contains(id ?? 00)
        setFavImage(isFavorite: isFavorite, animated: false)
        navigationItem.rightBarButtonItems = [shareItem, favItem, commentsButtonItem]
    }
    
    private func fetchPost() {
        activityIndicator.showIndicator(on: self)
        interactor?.fetchPostPage(request: PostModels.PostPage.Request())
    }
    
    private func fetchPostComments() {
        interactor?.fetchPostComments(request: PostModels.PostComments.Request())
    }
    
    private func fetchPostAuthor() {
        interactor?.fetchAuthorName(request: PostModels.AuthorName.Request())
    }
    
    private func scaleHeader() {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, self.topbarHeight + 3), 400)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        darkView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        postTitleLabel.frame = CGRect(x: 20, y: height - 100, width: UIScreen.main.bounds.size.width - 40, height: 100)
    }
    
    private func changeProgressViewValue(scrollView: UIScrollView) {
        if textView.contentSize.height > UIScreen.main.bounds.height {
            let offset = scrollView.contentOffset
            let percentageOfFullHeight = offset.y / (scrollView.contentSize.height - scrollView.frame.height)
            progressView.setProgress(Float(percentageOfFullHeight), animated: true)
        }
    }
    
    private func setFavImage(isFavorite: Bool, animated: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .medium)
        let emptyBM = UIImage(systemName: "flame", withConfiguration: config)
        let fillBM = UIImage(systemName: "flame.fill", withConfiguration: config)
        
        favButton.tintColor = isFavorite ? .systemRed : .white
        
        switch isFavorite {
        case true:
            favButton.setImageWithAnimation(fillBM, animated: animated)
        default:
            favButton.setImageWithAnimation(emptyBM, animated: animated)
        }
    }
    
    private func setAlphaForNB(scrollView: UIScrollView) {
        switch scrollView.contentOffset.y > 0 - (self.topbarHeight + 60) {
        case true:
            UIView.animate(withDuration: 0.20) {
                self.postTitleLabel.alpha = 0
            }
        case false:
            UIView.animate(withDuration: 0.25) {
                self.postTitleLabel.alpha = 1
            }
        }
    }
    
    private func setText(_ post: Post, _ completionBlock: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.postTitleLabel.text = post.title?.rendered.pureString()
            self.textView.setHTMLFromString(htmlText: post.content?.rendered ?? "", color: .postText)
            UIView.animate(withDuration: 0.35) {
                self.textView.alpha = 1
            }
            completionBlock()
        }
    }
    
    @objc private func routeToComments() {
        router?.routeToPostComments()
    }
    
    @objc private func savePostToFav() {
        interactor?.savePostToFav(request: PostModels.SaveToFavorites.Request())
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

// MARK: - Post Display Logic

extension PostViewController: PostDisplayLogic {
    
    func displayPostPage(viewModel: PostModels.PostPage.ViewModel) {
        guard let post = router?.dataStore?.post else { return }
        setText(post) { self.activityIndicator.hideIndicator() }
    }
    
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel) {
        rightNavItemsSetup()
    }
    
    func displayFavorites(viewModel: PostModels.SaveToFavorites.ViewModel) {
        setFavImage(isFavorite: viewModel.isFavorite, animated: true)
        if viewModel.isFavorite {
            router?.showAddToFavResultAlert(with: Text.Post.addedTF)
        } else {
            router?.showAddToFavResultAlert(with: Text.Post.removedFF)
        }
    }
    
    func displayAuthorName(viewModel: PostModels.AuthorName.ViewModel) {
        commentsButtonItem.isEnabled = true
    }
    
    func displayUI(viewModel: PostModels.Color.ViewModel) {
        createGradientLayer()
        showActivityIndicatorOnNavBarItem()
        scrollViewSetup()
        textViewSetup()
        fetchPostAuthor()
        fetchPost()
        setupHeader()
    }
    
}

extension PostViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scaleHeader()
        changeProgressViewValue(scrollView: scrollView)
        setAlphaForNB(scrollView: scrollView)
    }
    
}


