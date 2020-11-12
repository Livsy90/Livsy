//
//  PostCommentsViewController.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentsDisplayLogic: class {
    func displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel)
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel)
    func diplsySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel)
}

final class PostCommentsViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: PostCommentsBusinessLogic?
    var router: (PostCommentsRoutingLogic & PostCommentsDataPassing)?
    
    // MARK: - Private Properties
    private var refreshControl: UIRefreshControl!
    private var bottomConstraint = NSLayoutConstraint()
    private lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    private let noCommentsLabel: UILabel = {
        let l = UILabel()
        l.text = "Write the first comment"
        l.textColor = UIColor.postText.withAlphaComponent(0.3)
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 30.0)
        return l
    }()
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let activityIndicator = ActivityIndicator()
    private var safeArea: UILayoutGuide!
    
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
        PostCommentsConfigurator.sharedInstance.configure(viewController: self)
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
        showComments(isReload: false)
        setupNoCommentslabel()
        setupInputView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        } else {
            bottomConstraint.constant = -keyboardViewEndFrame.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 50, right: 0)
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { (completed) in
            
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
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        safeArea = view.layoutMarginsGuide
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .postListBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
    }
    
    private func setupInputView() {
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let bCons = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint = bCons
        view.addConstraint(bottomConstraint)
    }
    
    private func setupNoCommentslabel() {
        view.addSubview(noCommentsLabel)
        noCommentsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noCommentsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupNavBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .navBarTint
        if UserDefaults.standard.token == "" {
            let loginButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30))
            loginButton.setTitle("Login to reply", for: .normal)
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
    
    private  func showComments(isReload: Bool) {
        interactor?.showComments(request: PostCommentsModels.PostComments.Request(isReload: isReload))
    }
    
    private func showReplies(comment: PostComment, replies: [PostComment]) {
        interactor?.showReplies(request: PostCommentsModels.Replies.Request(comment: comment, replies: replies))
    }
    
    private func submitComment(content: String) {
        interactor?.submitComment(request: PostCommentsModels.SubmitComment.Request(content: content, post: router?.dataStore?.postID ?? 1))
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
    
    @objc private func dismissSelf() {
        router?.dismissSelf()
    }
    
    @objc private func refreshData() {
        interactor?.showComments(request: PostCommentsModels.PostComments.Request(isReload: true))
    }
    
}

// MARK: - PostComments Display Logic

extension PostCommentsViewController: PostCommentsDisplayLogic {
    
    func displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel) {
        tableView.softReload()
        noCommentsLabel.isHidden = !(router?.dataStore?.comments.isEmpty ?? true)
        refreshControl.endRefreshing()
        activityIndicator.hideIndicator()
    }
    
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel) {
        router?.routeToReplies()
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel) {
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showComments(isReload: true)
        } else {
            containerView.enableButton()
            activityIndicator.hideIndicator()
            router?.showAlert(with: viewModel.error?.message ?? "Oops.. Something went wrong!")
        }
    }
    
}

extension PostCommentsViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        scrollToRow { [weak self] (success) in
            guard let self = self else { return }
            if success {
                self.submitComment(content: comment)
            }
        }
        
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
        guard let comments = router?.dataStore?.comments else { return }
        showReplies(comment: comments[indexPath.row], replies: comments[indexPath.row].replies)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = router?.dataStore?.postTitle
        return title
    }
    
}

extension PostCommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        router?.dataStore?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comment = router?.dataStore?.comments[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier(), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        cell.config(comment: comment, isReplyButtonHidden: false)
        return cell
    }
    
}
