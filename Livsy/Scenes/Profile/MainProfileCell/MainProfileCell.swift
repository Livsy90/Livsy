//
//  MainProfileCell.swift
//  Livsy
//
//  Created by Artem on 31.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class MainProfileCell: UITableViewCell {
    
    var loginCompletion: (() -> Void)?
    
    private var mainImageView: WebImageView = {
        let v = WebImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        v.alpha = 0
        return v
    }()
    
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
        button.layer.cornerRadius = 8
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
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fill
        return sv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        list.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(list)
        stackView.addArrangedSubview(loginButton)
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 20, paddingRight: 40, width: 0, height: 0)
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupList() {
        let arrayOfLines = ["Leave comments", "See your profile information"]
        for value in arrayOfLines {
            list.text = ("\(list.text ?? "") • \(value)\n")
        }
    }
    
    func config(mainLabelText: String, isListHidden: Bool, loginButtonTitle: String) {
        setupList()
        mainLabel.text = mainLabelText
        loginButton.setTitle(loginButtonTitle, for: .normal)
        list.isHidden = isListHidden
    }
    
    @objc func handleLogin() {
        loginCompletion?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
