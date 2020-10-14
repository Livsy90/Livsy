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
}

final class RegisterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public Properties
    
    var interactor: RegisterBusinessLogic?
    var router: (RegisterRoutingLogic & RegisterDataPassing)?
    
    // MARK: - Private Properties
    
    private let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = .postBackground
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.layer.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.textColor = .postText
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = .postBackground
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        tf.layer.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.textColor = .postText
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.layer.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.backgroundColor = .postBackground
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
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
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
        view.backgroundColor = .listBackground
        title = "SignUp"
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
    
    @objc private func handleTextInputChange() {
        let isFormValid = loginTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .blueButton
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = .gray
        }
    }
    
    @objc private func handleSignUp() {
        guard let username = loginTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        signupButton.isUserInteractionEnabled = false
        interactor?.register(request: RegisterModels.Register.Request(username: username, email: email, password: password))
    }
    
}

// MARK: - Register Display Logic
extension RegisterViewController: RegisterDisplayLogic {
    func displayLogin(viewModel: RegisterModels.Register.ViewModel) {
        if viewModel.error == nil {
            self.navigationController?.popViewController(animated: true)
        }  else {
            showAlertWithOneButton(title: "Error", message: "", buttonTitle: "OK", buttonAction: nil)
        }
    }
    
    
}
