//
//  LoginViewController.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol LoginDisplayLogic: class {
    func displayLogin(viewModel: LoginModels.Login.ViewModel)
    func displayResetPassword(viewModel: LoginModels.ResetPassword.ViewModel)
}

protocol LoginSceneDelegate: class {
    func setupUIforLoggedIn()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: LoginBusinessLogic?
    var router: (LoginRoutingLogic & LoginDataPassing)?
    
    // MARK: - Private Properties
    
    private let activityIndicator = ActivityIndicator()
    
    private let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Text.SignUp.username
        tf.backgroundColor = .inputTextView
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.layer.cornerRadius = 8
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.textColor = .postText
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Text.SignUp.password
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .inputTextView
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.textColor = .postText
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Text.Login.login, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: Text.Login.dontHaveAccount, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: Text.SignUp.signUp, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.blueButton
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(Text.Login.forgotPassword, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.blueButton, for: .normal)
        
        button.addTarget(self, action: #selector(showResetPasswordAlert), for: .touchUpInside)
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
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .postBackground
        NotificationCenter.default.removeObserver(self)
        title = Text.Login.login
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        if UserDefaults.standard.token != "" {
            router?.dismissSelf(mode: router?.dataStore?.dismissMode ?? .toProfile)
        }
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(dontHaveAccountButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
        forgotPasswordButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        dontHaveAccountButton.anchor(top: forgotPasswordButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = loginTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .blueButton
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
    }
    
    @objc private func handleLogin() {
        guard let username = loginTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        loginButton.isUserInteractionEnabled = false
        interactor?.login(request: LoginModels.Login.Request(username: username, password: password))
        activityIndicator.showIndicator(on: self)
    }
    
    @objc private func handleShowSignUp() {
         let signUpController = RegisterViewController()
         navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc private func resetPassword(login: String) {
        interactor?.resetPassword(request: LoginModels.ResetPassword.Request(login: login))
    }
    
    @objc private func showResetPasswordAlert() {
        router?.showResetPasswordAlert(completion: resetPassword(login:))
    }
    
}

// MARK: - Login Display Logic
extension LoginViewController: LoginDisplayLogic {
    func displayLogin(viewModel: LoginModels.Login.ViewModel) {
        if viewModel.error == nil {
            router?.dismissSelf(mode: viewModel.dismissMode)
        } else {
            router?.showErrorAlert(with: viewModel.error?.message ?? "Username or password is wrong", completion: showResetPasswordAlert)
            loginButton.isUserInteractionEnabled = true
            activityIndicator.hideIndicator()
        }
    }
    
    func displayResetPassword(viewModel: LoginModels.ResetPassword.ViewModel) {
        if viewModel.error == nil {
            router?.showPasswordResultAlert(with: viewModel.result)
        } else {
            router?.showResetPasswordErrorAlert(with: viewModel.error?.message ?? "Error")
        }
        activityIndicator.hideIndicator()
    }
    
}
