//
//  TagsViewController.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol TagsDisplayLogic: class {
    func displayTags(viewModel: TagsModels.Tags.ViewModel)
}

protocol TagsViewControllerDelegate: class {
    func fetchPostListByTag(id: Int)
}

final class TagsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: TagsBusinessLogic?
    var router: (TagsRoutingLogic & TagsDataPassing)?
    weak var tagsViewControllerDelegate: TagsViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
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
        let interactor = TagsInteractor()
        let presenter = TagsPresenter()
        let router = TagsRouter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 180, height: tableView.contentSize.height + 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
      //  fetchtags()
        view.backgroundColor = .clear
    }
    
    // MARK: - Private Methods
    
    @objc func fetchtags() {
        interactor?.fetchTags(request: TagsModels.Tags.Request())
    }
    
    func setupTableView() {
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        tableView.backgroundView?.alpha = 0
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    }
    
}


// MARK: - Tags Display Logic

extension TagsViewController: TagsDisplayLogic {
    func displayTags(viewModel: TagsModels.Tags.ViewModel) {
        tableView.softReload()
    }
}


extension TagsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        router?.dataStore?.tags.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let tags = router?.dataStore?.tags else { return cell }
        cell.textLabel?.text = tags[indexPath.row].name
        cell.separatorInset = .zero
        cell.contentView.alpha = 0.3
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tagId = router?.dataStore?.tags[indexPath.row].id
        tagsViewControllerDelegate?.fetchPostListByTag(id: tagId ?? 00)
        dismiss(animated: true, completion: nil)
    }
    
}

extension TagsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tags"
    }
}

