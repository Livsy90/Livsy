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
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PostCommentRepliesBusinessLogic?
    var router: (PostCommentRepliesRoutingLogic & PostCommentRepliesDataPassing)?
    
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
    
    private var repliesCollectionView = RepliesCollectionView()
    
    private lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    private let addCommentButton = UIButton()
    
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
        PostCommentRepliesConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        showReplies(isReload: false)
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
            repliesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            repliesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 10, right: 10)
        }
        
        repliesCollectionView.scrollIndicatorInsets = repliesCollectionView.contentInset
    }
    
    private func setupLoginButton() {
        if UserDefaults.standard.token == nil || UserDefaults.standard.token == "" {
            view.addSubview(self.addCommentButton)
            addCommentButton.setTitleColor(.lightGray, for: .highlighted)
            addCommentButton.setTitle("Login to comment", for: .normal)
            addCommentButton.layer.cornerRadius = 5
            addCommentButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            addCommentButton.clipsToBounds = true
            addCommentButton.translatesAutoresizingMaskIntoConstraints = false
            addCommentButton.addTarget(self, action: #selector(routeToLogin), for: .touchUpInside)
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
    
    @objc private func routeToLogin() {
        router?.routeToLogin()
    }
    
    private func doOnDidLoad() {
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissSelf))
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
    
    // MARK: - Requests
    
    // MARK: - IBActions
    
}

// MARK: - PostCommentReplies Display Logic

extension PostCommentRepliesViewController: PostCommentRepliesDisplayLogic {
    
    func displayReplies(request: PostCommentRepliesModels.PostCommentReplies.ViewModel) {
        guard let comments = router?.dataStore?.replies else { return }
        repliesCollectionView.set(comments: comments)
        repliesCollectionView.reloadData()
    }
    
    func diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel) {
        if viewModel.error == nil {
            containerView.clearCommentTextField()
            showReplies(isReload: true)
        } else {
            showAlertWithOneButton(title: "Error", message: "Please, check your comment", buttonTitle: "OK", buttonAction: nil)
        }
    }
    
}

extension PostCommentRepliesViewController: CommentInputAccessoryViewDelegate {
    
    func didSubmit(for comment: String) {
        submitComment(content: comment)
    }
    
    
}
