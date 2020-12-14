//
//  PostCommentRepliesViewController.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentRepliesDisplayLogic: AnyObject {
    func displayReplies(viewModel: PostCommentRepliesModels.PostCommentReplies.ViewModel)
    func diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel)
}

final class PostCommentRepliesViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: PostCommentRepliesBusinessLogic?
    var router: (PostCommentRepliesRoutingLogic & PostCommentRepliesDataPassing)?
    
    // MARK: - Private Properties
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let activityIndicator = ActivityIndicator()
    private let effect = UIBlurEffect(style: .prominent)
    private let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    private let arrowImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .medium, scale: .large)
        let image = UIImage(systemName: "arrow.up.circle", withConfiguration: config)
        let v = UIImageView(image: image)
        v.tintColor = .lightGray
        return v
    }()
    
    private var repliesCollectionView = RepliesCollectionView()
    private var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    private lazy var loginBarButtonItem = UIBarButtonItem(title: Text.Comments.loginToReply, style: .done, target: self, action: #selector(routeToLogin))
    
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
        let interactor = PostCommentRepliesInteractor()
        let presenter = PostCommentRepliesPresenter()
        let router = PostCommentRepliesRouter()
        let worker = PostCommentRepliesWorker()
        
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
        title = Text.Comments.repliesCapital
        setupTableView()
        showReplies(isReload: false, isSubmitted: false)
        addSwipeToPopGesture()
        setupArrowImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        backgroundImageView.image = router?.dataStore?.image ?? UIImage()
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
        tableView.backgroundColor = .clear
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = resizingMask
        backgroundView.addSubview(self.buildImageView())
        backgroundView.addSubview(self.buildBlurView())
        
        tableView.backgroundView = backgroundView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: effect)
    }
    
    private func setupArrowImageView() {
        let size = 45
        let screenWidth = self.view.frame.size.width
        let frame = CGRect(x: (Int(screenWidth) / 2) - (size / 2), y: 70, width: size, height: size)
        arrowImageView.frame = frame
        self.view.addSubview(arrowImageView)
    }
    
    private func buildImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage())
        imageView.frame = view.bounds
        imageView.autoresizingMask = resizingMask
        return imageView
    }
    
    private func buildBlurView() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = resizingMask
        return blurView
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 50, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func refreshData() {
        interactor?.showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request(isReload: true, isSubmitted: false))
    }
    
    private func setupNavBar() {
        let closeItem = UIBarButtonItem(title: Text.Common.back, style: .done, target: self, action: #selector(dismissSelf))
        navigationItem.leftBarButtonItem = closeItem
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
        if UserDefaults.standard.token == "" {
            navigationItem.rightBarButtonItem = loginBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func dismissSelf() {
        router?.dismissSelf()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func addSwipeToPopGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissSelf))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    private func setupCollectionView() {
        view.addSubview(repliesCollectionView)
        repliesCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        repliesCollectionView.keyboardDismissMode = .interactive
    }
    
    private func showReplies(isReload: Bool, isSubmitted: Bool) {
        tableView.allowsSelection = false
        interactor?.showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request(isReload: isReload, isSubmitted: isSubmitted))
    }
    
    private func submitComment(content: String) {
        activityIndicator.showIndicator(on: self)
        interactor?.showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request(content: content, post: router?.dataStore?.postID ?? 0))
    }
    
}

// MARK: - PostCommentReplies Display Logic

extension PostCommentRepliesViewController: PostCommentRepliesDisplayLogic {
    
    func displayReplies(viewModel: PostCommentRepliesModels.PostCommentReplies.ViewModel) {
        let comments = router?.dataStore?.replies ?? []
        let isShouldInsertRow = viewModel.isOneCommentAppended && viewModel.isSubmited && !viewModel.isEditedByWeb
        activityIndicator.hideIndicator()
        isShouldInsertRow ? tableView.insertRows(at: [IndexPath(item: comments.count - 1, section: 1)], with: .right) : tableView.softReload()
        tableView.allowsSelection = false
        
        switch viewModel.isSubmited {
        case true:
            if tableView.visibleCells.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let item = self.router?.dataStore?.replies.count else { return }
                    self.tableView.scrollToRow(at: IndexPath(item: item - 1, section: 1), at: .bottom, animated: true)
                }
            }
            
        case false:
            return
        }
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel) {
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showReplies(isReload: true, isSubmitted: true)
        } else {
            containerView.enableButton()
            router?.showAlert(with: viewModel.error?.message ?? "Oops.. Something went wrong!")
            activityIndicator.hideIndicator()
        }
    }
    
}

extension PostCommentRepliesViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        submitComment(content: comment)
    }
    
    func routeToLoginScene() {
        router?.routeToLogin()
    }
    
}

extension PostCommentRepliesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Text.Post.comment
        default:
            guard let commentReplies = router?.dataStore?.replies else { return Text.Comments.noReplies }
            return commentReplies.isEmpty ? Text.Comments.noReplies : Text.Comments.replies
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            UIView.animate(withDuration: 0.2) {
                self.arrowImageView.frame.origin.y = self.topbarHeight + 10
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.arrowImageView.frame.origin.y = -(self.topbarHeight + 10)
            }
        }
        
        if scrollView.contentOffset.y < -170 {
            dismissSelf()
        }
    }
    
}

extension PostCommentRepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return router?.dataStore?.replies.count ?? 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postAuthorName = router?.dataStore?.authorName ?? ""
        guard let parentComment = router?.dataStore?.parentComment else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier(), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.config(comment: parentComment, isReplyButtonHidden: true, postAuthorName: postAuthorName)
            cell.selectionStyle = .none
            return cell
        default:
            if !(router?.dataStore?.replies.isEmpty ?? true) {
                guard let commArray = router?.dataStore?.replies else { return UITableViewCell() }
                let comment = commArray[indexPath.row]
                cell.config(comment: comment, isReplyButtonHidden: true, postAuthorName: postAuthorName)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

extension PostCommentRepliesViewController {
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

