//
//  RegisterViewController.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol RegisterDisplayLogic: class {
    func displayLogin(viewModel: RegisterModels.Register.ViewModel)
    func displayLogin(viewModel: RegisterModels.Login.ViewModel)
}

final class RegisterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: RegisterBusinessLogic?
    var router: (RegisterRoutingLogic & RegisterDataPassing)?
    
    // MARK: - Private Properties
    
    private let activityIndicator = ActivityIndicator()
    
    private let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = .inputTextView
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.layer.cornerRadius = 8
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.textColor = .postText
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
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
        tf.placeholder = "Password"
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
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
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
        RegisterConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputFields()
        view.backgroundColor = .postBackground
        title = "Sign up"
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.token != "" {
            navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, emailTextField, signupButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 180)
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = loginTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && validateEmail(enteredEmail: emailTextField.text ?? "")
        
        if isFormValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .blueButton
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
    }
    
    @objc private func handleSignUp() {
        guard let username = loginTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        signupButton.isUserInteractionEnabled = false
        signupButton.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        activityIndicator.showIndicator(on: self)
        interactor?.register(request: RegisterModels.Register.Request(username: username, email: email, password: password))
    }
    
}

// MARK: - Register Display Logic

extension RegisterViewController: RegisterDisplayLogic {
    
    func displayLogin(viewModel: RegisterModels.Register.ViewModel) {
        if viewModel.error == nil {
            interactor?.login(request: RegisterModels.Login.Request(username: loginTextField.text ?? "", password: passwordTextField.text ?? ""))
        }  else {
            router?.showAlert(with: viewModel.error?.message ?? "Error")
            signupButton.isUserInteractionEnabled = true
            signupButton.backgroundColor = .blueButton
            activityIndicator.hideIndicator()
        }
    }
    
    func displayLogin(viewModel: RegisterModels.Login.ViewModel) {
        activityIndicator.hideIndicator()
        if viewModel.error == nil {
            router?.dismissSelf(username: viewModel.username, password: viewModel.password)
        } else {
            router?.showAlert(with: viewModel.error?.message ?? "Error")
        }
        
    }
    
}
