//
//  PostListCollectionViewCell.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class PostListCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PostListCollectionViewCell"
    
    let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    let mainImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let smallDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.init(named: "PostListText")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
        self.layer.backgroundColor = UIColor.rowBackground.cgColor
        self.clipsToBounds = false
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        DispatchQueue.main.async {
            self.mainImageView.layer.masksToBounds = true
            self.mainImageView.layer.cornerRadius = 15
            self.mainImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageUrl: String?) {
        mainImageView.set(imageURL: imageUrl)
    }
    
    private func setup() {
        addSubview(smallDescriptionLabel)
        addSubview(mainImageView)
        mainImageView.addSubview(darkView)
        mainImageView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, constant: 16).isActive = true
        darkView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        darkView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
        darkView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor).isActive = true
        darkView.heightAnchor.constraint(equalTo: mainImageView.heightAnchor).isActive = true
        mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: Constants.postListImageHeight)
        smallDescriptionLabel.anchor(top: mainImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 5, paddingRight: 16, width: 0, height: 0)
        mainImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        mainImageView.contentMode = .scaleAspectFill
    }
    
}
