//
//  ProfileViewController.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: class {
    func displaySignOut()
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Private Properties
    
    private let greetingsText = "Login or sign up to:"
    private let list: UILabel = {
        let label = UILabel()
        let hasToken = UserDefaults.standard.token != ""
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .authorName
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = hasToken
        return label
    }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blueButton
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .titleGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UserDefaults.standard.username
        return label
    }()
    
    private let stackView: UIStackView = {
       let sw = UIStackView()
        sw.axis = .vertical
        sw.spacing = 20
        sw.distribution = .fill
        return sw
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
        ProfileConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Profile"
        view.backgroundColor = .postBackground
        let name = UserDefaults.standard.username
        mainLabel.text = name == "" ? greetingsText : name
        loginButton.setTitle(UserDefaults.standard.username == "" ? "Continue" : "Sign Out", for: .normal)
//        let boldLargeConfig = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .bold, scale: .large)
//        let boldSmallSymbolImage = UIImage(systemName: "captions.bubble.fill", withConfiguration: boldLargeConfig)
//        let v = UIImageView(image: boldSmallSymbolImage)
        setupList()
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(list)
        stackView.addArrangedSubview(loginButton)
//        stackView.addArrangedSubview(v)
        view.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
    }
    
    private func setupList() {
        let arrayOfLines = ["Leave comments", "See your profile information", "Get list of all the comments you left"]
        for value in arrayOfLines {
            list.text = ("\(list.text ?? "") • \(value)\n")
         }
    }
    
    private func signOut() {
        interactor?.signOut()
    }
    
    private func showSignOutQuestion() {
        router?.showSignOutQuestionAlert(completion: signOut)
    }
    
    private func changeUI(labelText: String, buttontext: String) {
        loginButton.setTitle(buttontext, for: .normal)
        UIView.transition(with: mainLabel,
             duration: 0.4,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.mainLabel.text = labelText
        }, completion: nil)
    }
    
    @objc private func handleLogin() {
        switch UserDefaults.standard.token != "" {
        case true:
            showSignOutQuestion()
        default:
            router?.routeToLogin()
        }
    }
    
}

// MARK: - Profile Display Logic
extension ProfileViewController: ProfileDisplayLogic {
    
    func displaySignOut() {
        router?.showSignOutResultAlert()
        changeUI(labelText: greetingsText, buttontext: "Continue")
        UIView.animate(withDuration: 0.3){
            self.list.isHidden = false
        }
    }
    
}

extension ProfileViewController: LoginSceneDelegate {
    
    func changelabel() {
        guard let text = UserDefaults.standard.username else { return }
        changeUI(labelText: text, buttontext: "Sign out")
        UIView.animate(withDuration: 0.3){
            self.list.isHidden = true
        }
    }
    
}
