//
//  PostCommentsViewController.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentsDisplayLogic: AnyObject {
    func displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel)
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel)
    func displaySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel)
}

final class PostCommentsViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: PostCommentsBusinessLogic?
    var router: (PostCommentsRoutingLogic & PostCommentsDataPassing)?
    
    // MARK: - Private Properties
    private let noCommentsLabel: UILabel = {
        let l = UILabel()
        l.text = Text.Comments.beTheFirst
        l.textColor = UIColor.postText.withAlphaComponent(0.3)
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 30.0)
        return l
    }()
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let activityIndicator = ActivityIndicator()
    private let effect = UIBlurEffect(style: .prominent)
    private let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    private var refreshControl: UIRefreshControl!
    private var isShouldReload: Bool = false
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
        let interactor = PostCommentsInteractor()
        let presenter = PostCommentsPresenter()
        let router = PostCommentsRouter()
        let worker = PostCommentsWorker()
        
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    // MARK: - Lifecycle
    
    override func viewWillLayoutSubviews() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .postBackground
        setupTableView()
        setupRefreshControl()
        setupNoCommentslabel()
        setupNoCommentslabel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showComments(isReload: isShouldReload, isSubmitted: false)
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
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
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func setupTableView() {
        backgroundImageView.image = router?.dataStore?.image ?? UIImage()
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = resizingMask
        backgroundView.addSubview(self.buildImageView())
        backgroundView.addSubview(self.buildBlurView())
        
        tableView.backgroundView = backgroundView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: effect)
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
    
    
    
    private func setupNoCommentslabel() {
        tableView.addSubview(noCommentsLabel)
        noCommentsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noCommentsLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -50).isActive = true
    }
    
    private func setupNavBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
        if UserDefaults.standard.token == "" {
            navigationItem.rightBarButtonItem = loginBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private  func showComments(isReload: Bool, isSubmitted: Bool) {
        tableView.allowsSelection = false
        interactor?.showComments(request: PostCommentsModels.PostComments.Request(isReload: isReload, isSubmitted: isSubmitted))
    }
    
    private func showReplies(comment: PostComment, replies: [PostComment]) {
        interactor?.showReplies(request: PostCommentsModels.Replies.Request(comment: comment, replies: replies))
    }
    
    private func submitComment(content: String) {
        activityIndicator.showIndicator(on: self)
        interactor?.submitComment(request: PostCommentsModels.SubmitComment.Request(content: content, post: router?.dataStore?.postID ?? 1))
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func dismissSelf() {
        router?.dismissSelf()
    }
    
    @objc private func refreshData() {
        interactor?.showComments(request: PostCommentsModels.PostComments.Request(isReload: true, isSubmitted: false))
    }
    
}

// MARK: - PostComments Display Logic

extension PostCommentsViewController: PostCommentsDisplayLogic {
    
    func displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel) {
        let comments = router?.dataStore?.comments ?? []
        let isShouldInsertRow = viewModel.isOneCommentAppended && viewModel.isSubmited && !viewModel.isEditedByWeb
        noCommentsLabel.isHidden = !comments.isEmpty
        refreshControl.endRefreshing()
        activityIndicator.hideIndicator()
        isShouldInsertRow ? tableView.insertRows(at: [IndexPath(item: comments.count - 1, section: 0)], with: .right) : tableView.softReload()
        tableView.allowsSelection = true
        
        switch viewModel.isSubmited {
        case true:
            if tableView.visibleCells.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let item = self.router?.dataStore?.comments.count else { return }
                    self.tableView.scrollToRow(at: IndexPath(item: item - 1, section: 0), at: .bottom, animated: true)
                }
            }
            
        case false:
            return
        }
    }
    
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel) {
        router?.routeToReplies()
    }
    
    func displaySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel) {
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showComments(isReload: true, isSubmitted: true)
        } else {
            containerView.enableButton()
            router?.showAlert(with: viewModel.error?.message ?? "Oops.. Something went wrong!")
            activityIndicator.hideIndicator()
        }
    }
    
}

extension PostCommentsViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        submitComment(content: comment)
    }
    
    func routeToLoginScene() {
        router?.routeToLogin()
    }
    
}

extension PostCommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        isShouldReload = true
        guard let comments = router?.dataStore?.comments else { return }
        showReplies(comment: comments[indexPath.row], replies: comments[indexPath.row].replies)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = router?.dataStore?.postTitle.pureString()
        return title
    }
    
}

extension PostCommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        router?.dataStore?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postAuthorName = router?.dataStore?.authorName ?? ""
        guard let comment = router?.dataStore?.comments[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier(), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        cell.config(comment: comment, isReplyButtonHidden: false, postAuthorName: postAuthorName)
        return cell
    }
    
}

extension PostCommentsViewController {
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

