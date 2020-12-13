//
//  PageViewController.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PageDisplayLogic: AnyObject {

    func displayPage(viewModel: PageModels.Page.ViewModel)
    
}

final class PageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PageBusinessLogic?
    var router: (PageRoutingLogic & PageDataPassing)?
    
    // MARK: - Private Properties
    
    private let textView = CustomTextView()
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let activityIndicator = ActivityIndicator()
    
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
        let interactor = PageInteractor()
        let presenter = PagePresenter()
        let router = PageRouter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPage()
    }
    
    // MARK: - Private Methods
    
    private func fetchPage() {
        activityIndicator.showIndicator(on: self)
        interactor?.fetchpage(request: PageListModels.Page.Request())
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.backgroundColor = .postBackground
        
        scrollView.addSubview(titleLabel)
        titleLabel.textColor = .bodyText
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 26)
        titleLabel.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        textView.backgroundColor = .clear
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        textView.anchor(top: titleLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .bodyText
        textView.textAlignment = .left
    }
    
}

// MARK: - Page Display Logic
extension PageViewController: PageDisplayLogic {
    
    func displayPage(viewModel: PageModels.Page.ViewModel) {
        titleLabel.text = router?.dataStore?.title ?? ""
        let text = router?.dataStore?.content ?? ""
        textView.setHTMLFromString(htmlText: text, color: .postText)
        activityIndicator.hideIndicator()
    }
    
}
