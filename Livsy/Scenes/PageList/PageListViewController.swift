//
//  PageListViewController.swift
//  Livsy
//
//  Created by Artem on 26.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PageListDisplayLogic: class {
    
}

protocol PageListViewControllerDelegate: class {
    func routeToPage(id: Int)
}

final class PageListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: PageListBusinessLogic?
    var router: (PageListRoutingLogic & PageListDataPassing)?
    weak var pageListViewControllerDelegate: PageListViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let effect = UIBlurEffect(style: .systemUltraThinMaterial)
    private let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    
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
        let interactor = PageListInteractor()
        let presenter = PageListPresenter()
        let router = PageListRouter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 180, height: tableView.contentSize.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = .clear
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .clear
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = resizingMask
        backgroundView.addSubview(self.buildImageView())
        backgroundView.addSubview(self.buildBlurView())
        
        tableView.backgroundView = backgroundView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: effect)
        tableView.isScrollEnabled = UIScreen.main.bounds.height < tableView.contentSize.height + 300
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
    
}


// MARK: - Tags Display Logic

extension PageListViewController: PageListDisplayLogic {
    
}

extension PageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        router?.dataStore?.pageList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let tags = router?.dataStore?.pageList else { return cell }
        cell.textLabel?.text = tags[indexPath.row].title?.rendered.pureString()
        cell.separatorInset = .zero
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageId = router?.dataStore?.pageList[indexPath.row].id ?? 2
        pageListViewControllerDelegate?.routeToPage(id: pageId)
        dismiss(animated: true, completion: nil)
    }
    
}

extension PageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Pages"
    }
    
}
