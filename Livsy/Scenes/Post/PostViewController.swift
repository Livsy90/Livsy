//
//  PostViewController.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostDisplayLogic: class {
    func displayPostPage(viewModel: PostModels.PostPage.ViewModel)
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel)
}

final class PostViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PostBusinessLogic?
    var router: (PostRoutingLogic & PostDataPassing)?
    var id = 0
    let textView = UITextView()
    let scrollView = UIScrollView()
    let postTitle = UILabel()
    
    // MARK: - Private Properties
    
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
        PostConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewSetup()
        postTitleSetup()
        textViewSetup()
        fetchPost()
    }
        
    // MARK: - Private Methods
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.addSubview(postTitle)
        scrollView.backgroundColor = #colorLiteral(red: 0.9999561906, green: 0.9990209937, blue: 0.9686461091, alpha: 1)
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func postTitleSetup() {
        postTitle.font = .systemFont(ofSize: 30, weight: .semibold)
        postTitle.textColor = .darkText
        postTitle.lineBreakMode = .byWordWrapping
        postTitle.numberOfLines = 0
        postTitle.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: textView.topAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func textViewSetup() {
        textView.backgroundColor = .clear
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        textView.anchor(top: postTitle.bottomAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textAlignment = .left
    }
    
    private func commentsButtonSetup() {
        guard let count = router?.dataStore?.comments.count else { return }
        let barButton = UIBarButtonItem(title: "Comments (\(count))", style: .plain, target: self, action: #selector(routeToComments))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func routeToComments() {
        router?.routeToPostComments()
    }
    
    private func fetchPost() {
        interactor?.fetchPostPage(request: PostModels.PostPage.Request())
    }
    
    private func fetchPostComments() {
        interactor?.fetchPostComments(request: PostModels.PostComments.Request())
    }
    
    // MARK: - Requests
    
    // MARK: - IBActions
    
}

// MARK: - Post Display Logic
extension PostViewController: PostDisplayLogic {
    
    func displayPostPage(viewModel: PostModels.PostPage.ViewModel) {
        postTitle.text = router?.dataStore?.title ?? ""
        textView.setHTMLFromString(htmlText: router?.dataStore?.content ?? "")
        fetchPostComments()
    }
    
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel) {
        commentsButtonSetup()
    }
    
}
