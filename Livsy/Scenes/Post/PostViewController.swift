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
    // MARK: - Public Properties
    
    var interactor: PostBusinessLogic?
    var router: (PostRoutingLogic & PostDataPassing)?
    var id = 0
    let textView = CustomTextView()
    let scrollView = UIScrollView()
    let postTitle = UILabel()
    let imageView = WebImageView()
    let lblName = UILabel()
    let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Private Properties
    
    private var link = ""
    private let activityIndicator = ActivityIndicator()
    private let loadingCommentsIndicator = UIActivityIndicatorView()
    private let darkBlurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let lightBlurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
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
        showActivityIndicatorOnNavBarItem()
        createGradientLayer()
        scrollViewSetup()
        textViewSetup()
        setupHeader()
        fetchPost()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            createGradientLayer()
            view.bringSubviewToFront(scrollView)
            view.bringSubviewToFront(imageView)
            
        }
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
        postTitle.frame = CGRect(x: 20, y: 400, width: UIScreen.main.bounds.width - 40, height: 200)
        postTitle.font = UIFont.systemFont(ofSize: 26)
        postTitle.clipsToBounds = true
        imageView.addSubview(postTitle)
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        guard let color1 = router?.dataStore?.image.averageColor?.cgColor else { return }
        gradientLayer.colors = [color1, UIColor.postBackground.cgColor, UIColor.postBackground.cgColor, UIColor.navBarTint.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        
        let imageView = UIImageView(image: UIImage(named: "blur"))
        imageView.frame = view.bounds
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        if traitCollection.userInterfaceStyle == .light {
            darkBlurredEffectView.removeFromSuperview()
            lightBlurredEffectView.frame = imageView.bounds
            view.addSubview(lightBlurredEffectView)
        } else {
            lightBlurredEffectView.removeFromSuperview()
            darkBlurredEffectView.frame = imageView.bounds
            view.addSubview(darkBlurredEffectView)
        }

    }
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentInset = UIEdgeInsets(top: 150, left: 20, bottom: 0, right: 20)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func postTitleSetup() {
        postTitle.textColor = .white
        postTitle.lineBreakMode = .byWordWrapping
        postTitle.numberOfLines = 0
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
    }
    
    private func showActivityIndicatorOnNavBarItem() {
        loadingCommentsIndicator.hidesWhenStopped = true
        loadingCommentsIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingCommentsIndicator)
    }
    
    private func commentsButtonSetup() {
        loadingCommentsIndicator.stopAnimating()
        guard let count = router?.dataStore?.comments.count else { return }
        let barButton = UIBarButtonItem(title: "Comments (\(count))", style: .plain, target: self, action: #selector(routeToComments))
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func fetchPost() {
        activityIndicator.showIndicator(on: self)
        interactor?.fetchPostPage(request: PostModels.PostPage.Request())
    }
    
    private func fetchPostComments() {
        interactor?.fetchPostComments(request: PostModels.PostComments.Request())
    }
    
    @objc private func openURL() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func routeToComments() {
        router?.routeToPostComments()
    }
    
}

// MARK: - Post Display Logic
extension PostViewController: PostDisplayLogic {
    
    func displayPostPage(viewModel: PostModels.PostPage.ViewModel) {
        postTitle.text = router?.dataStore?.title ?? ""
        textView.setHTMLFromString(htmlText: router?.dataStore?.content ?? "", color: .postText)
        fetchPostComments()
        activityIndicator.hideIndicator()
    }
    
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel) {
        commentsButtonSetup()
    }
    
}

extension PostViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        darkView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        postTitle.frame = CGRect(x: 20, y: height - 100, width: UIScreen.main.bounds.size.width - 40, height: 100)
    }
}
