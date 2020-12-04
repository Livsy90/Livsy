//
//  PostCommentRepliesViewController.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentRepliesDisplayLogic: class {
    func displayReplies(request: PostCommentRepliesModels.PostCommentReplies.ViewModel)
    func diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel)
}

final class PostCommentRepliesViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: PostCommentRepliesBusinessLogic?
    var router: (PostCommentRepliesRoutingLogic & PostCommentRepliesDataPassing)?
    
    // MARK: - Private Properties
    
    private var refreshControl: UIRefreshControl!
    private var repliesCollectionView = RepliesCollectionView()
    private var bottomConstraint = NSLayoutConstraint()
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let activityIndicator = ActivityIndicator()
    private let effect = UIBlurEffect(style: .prominent)
    private let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    private lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
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
        setupRefreshControl()
        setupTableView()
        setupInputView()
        showReplies(isReload: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        let imgView = UIImageView(image: router?.dataStore?.image ?? UIImage())
        view.addSubview(imgView)
        imgView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: imgView.topAnchor, left: imgView.leftAnchor, bottom: imgView.bottomAnchor, right: imgView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
        tableView.backgroundColor = .clear
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = resizingMask
        backgroundView.addSubview(self.buildImageView())
        backgroundView.addSubview(self.buildBlurView())
        
        tableView.backgroundView = backgroundView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: effect)
    }
    
    private func buildImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "img"))
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
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    private func setupInputView() {
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let bCons = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint = bCons
        view.addConstraint(bottomConstraint)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            bottomConstraint.constant = 0
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 50, right: 0)
            bottomConstraint.constant = -keyboardViewEndFrame.height
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { (completed) in
            
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    private func scrollToRow(completion: (_ success: Bool) -> Void) {
        activityIndicator.showIndicator(on: self)
        if tableView.visibleCells.count > 0 {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
        completion(true)
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func refreshData() {
        interactor?.showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request(isReload: true))
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
        
        if UserDefaults.standard.token == "" {
            let loginButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30))
            loginButton.setTitle(Text.Comments.loginToReply, for: .normal)
            loginButton.layer.cornerRadius = 8
            loginButton.layer.borderWidth = 1
            loginButton.layer.borderColor = UIColor.navBarTint.cgColor
            loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            loginButton.setTitleColor(.navBarTint, for: .normal)
            loginButton.addTarget(self, action: #selector(routeToLogin), for: .touchUpInside)
            loginButton.isEnabled = false
            let item =  UIBarButtonItem(customView: loginButton)
            navigationItem.rightBarButtonItem = item
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func dismissSelf() {
        router?.dismissSelf()
    }
    
    private func setupCollectionView() {
        view.addSubview(repliesCollectionView)
        repliesCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        repliesCollectionView.keyboardDismissMode = .interactive
    }
    
    private func showReplies(isReload: Bool) {
        interactor?.showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request(isReload: isReload))
    }
    
    private func submitComment(content: String) {
        interactor?.showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request(content: content, post: router?.dataStore?.postID ?? 0))
    }
    
}

// MARK: - PostCommentReplies Display Logic

extension PostCommentRepliesViewController: PostCommentRepliesDisplayLogic {
    
    func displayReplies(request: PostCommentRepliesModels.PostCommentReplies.ViewModel) {
        tableView.softReload()
        refreshControl.endRefreshing()
        activityIndicator.hideIndicator()
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel) {
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showReplies(isReload: true)
        } else {
            containerView.enableButton()
            router?.showAlert(with: viewModel.error?.message ?? "Oops.. Something went wrong!")
            activityIndicator.hideIndicator()
        }
    }
    
}

extension PostCommentRepliesViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        scrollToRow { [weak self] (success) in
            guard let self = self else { return }
            self.submitComment(content: comment)
        }
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
            return ""
        default:
            guard let commentReplies = router?.dataStore?.replies else { return Text.Comments.noReplies }
            return commentReplies.isEmpty ? Text.Comments.noReplies : Text.Comments.replies
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
