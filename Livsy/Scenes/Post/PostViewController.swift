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
    
    // MARK: - Private Properties
    
    private var link = ""
    private let activityIndicator = ActivityIndicator()
    private let loadingCommentsIndicator = UIActivityIndicatorView()
    
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
        scrollView.backgroundColor = UIColor.init(named: "PostBackground")
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
        textView.textColor = .systemGray6
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
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
    
    private func formatString(text: String, with width: Float) -> String {
        
        let iframe_texts = matches(for: ".*iframe.*", in: text);
        var new_text = text;
        
        if iframe_texts.count > 0 {
            
            for iframe_text in iframe_texts {
                let iframe_id = matches(for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", in: iframe_text);
                
                if iframe_id.count > 0 {
                    
                    new_text = new_text.replacingOccurrences(of: iframe_text, with:"<a href='https://www.youtube.com/watch?v=\(iframe_id[0])'><img src=\"https://img.youtube.com/vi/" + iframe_id[0] + "/maxresdefault.jpg\" alt=\"\" width=\"\(width)\" /></a>");
                    
                }
            }
        }
        
        return new_text;
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex,  options: .caseInsensitive)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
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
        let rect = self.view.window?.frame
        postTitle.text = router?.dataStore?.title ?? ""
        textView.setHTMLFromString(htmlText: formatString(text: router?.dataStore?.content ?? "", with: Float(rect?.size.width ?? 375)))
        fetchPostComments()
        activityIndicator.hideIndicator()
    }
    
    func displayPostComments(viewModel: PostModels.PostComments.ViewModel) {
        commentsButtonSetup()
    }
    
}
