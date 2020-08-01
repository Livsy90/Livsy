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
            if UserDefaults.standard.token != nil {
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
    
    private let postCommentsCollectionView = PostCommentsCollectionView()
    private let addCommentButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.gray, for: .highlighted)
        button.setTitle("Login to comment", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(routeToLogin), for: .touchUpInside)
        return button
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
        PostCommentsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        showComments(isReload: false)
        doOnDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLoginButton()
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
            postCommentsCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            postCommentsCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 10, right: 10)
        }

        postCommentsCollectionView.scrollIndicatorInsets = postCommentsCollectionView.contentInset
    }
    
    private func doOnDidLoad() {
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissSelf))
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
    
    private func setupLoginButton() {
        if UserDefaults.standard.token == nil {
            view.addSubview(self.addCommentButton)
            NSLayoutConstraint.activate([
                addCommentButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                addCommentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25),
                addCommentButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                addCommentButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                addCommentButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            addCommentButton.removeFromSuperview()
        }
        
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
        guard let comments = router?.dataStore?.comments else { return } 
        postCommentsCollectionView.set(comments: comments)
        postCommentsCollectionView.reloadData()
    }
    
    func diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel) {
        router?.routeToReplies()
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel) {
        
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showComments(isReload: true)
        } else {
            showAlertWithOneButton(title: "Error", message: "Please, check your comment", buttonTitle: "OK", buttonAction: nil)
        }
    }
    
}

extension PostCommentsViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        submitComment(content: comment)
    }
    
}
