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
    
    override var inputAccessoryView: UIView? {
        get {
            if UserDefaults.standard.token != "" {
                return containerView
            } else {
                return nil
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Private Properties
    
    private lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    private var safeArea: UILayoutGuide!
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
    private let postCommentsCollectionView = PostCommentsCollectionView()
    private let tableView = UITableView()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         setupCollectionView()
        setupTableView()
        setupNoCommentslabel()
        showComments(isReload: false)
        setupNoCommentslabel()
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
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
//            postCommentsCollectionView
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
//            postCommentsCollectionView
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
//        postCommentsCollectionView.scrollIndicatorInsets = postCommentsCollectionView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func setupTableView() {
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        safeArea = view.layoutMarginsGuide
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: safeArea.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .postListBackground
        tableView.keyboardDismissMode = .interactive
        tableView.register(UINib(nibName: CommentsTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier())
    }
    
    private func setupNoCommentslabel() {
        view.addSubview(noCommentsLabel)
        noCommentsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noCommentsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupNavBar() {
        view.backgroundColor = .postBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissSelf))
        if UserDefaults.standard.token == "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login to reply", style: .plain, target: self, action: #selector(routeToLogin))
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(postCommentsCollectionView)
        postCommentsCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postCommentsCollectionView.cellTappedCompletion = { [weak self] (comment, replies) in
            guard let self = self else { return }
            self.showReplies(comment: comment, replies: replies)
        }
        postCommentsCollectionView.keyboardDismissMode = .interactive
    }
    
    private func showComments(isReload: Bool) {
        interactor?.showComments(request: PostCommentsModels.PostComments.Request(isReload: isReload))
    }
    
    private func showReplies(comment: PostComment, replies: [PostComment]) {
        interactor?.showReplies(request: PostCommentsModels.Replies.Request(comment: comment, replies: replies))
    }
    
    private func submitComment(content: String) {
        interactor?.submitComment(request: PostCommentsModels.SubmitComment.Request(content: content, post: router?.dataStore?.postID ?? 1))
    }
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    @objc private func dismissSelf() {
        router?.dismissSelf()
    }
    
}

// MARK: - PostComments Display Logic

extension PostCommentsViewController: PostCommentsDisplayLogic {
    
    func displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel) {
//        guard let comments = router?.dataStore?.comments else { return }
//          postCommentsCollectionView.set(comments: comments)
//          postCommentsCollectionView.reloadData()
        viewModel.isReload ? tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .middle) : tableView.reloadData()
        noCommentsLabel.isHidden = !(router?.dataStore?.comments.isEmpty ?? true)
    }
    
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel) {
        router?.routeToReplies()
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel) {
        
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showComments(isReload: true)
        } else {
            router?.showAlert(with: viewModel.error?.message ?? "Oops.. Something went wrong!")
        }
    }
    
}

extension PostCommentsViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        submitComment(content: comment)
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
    
}

extension PostCommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        router?.dataStore?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comment = router?.dataStore?.comments[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier(), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        cell.config(comment: comment)
        return cell
    }
    
    
}
