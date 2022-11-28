//
//  PostListCollectionViewCell.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

final class PostListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let postListImageHeight: CGFloat = 130
        static let flameFillImageName = "flame.fill"
        static let imageCornerRadius: CGFloat = 13
        static let postCornerRadius: CGFloat = 15
        static let nameLabelWidthConstant: CGFloat = -16
        
        // MARK: - Layout constants
        
        static let favImageViewInsets = UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: 10)
        static let favImageViewSideSize: CGFloat = .zero
        
        static let dateLabelViewInsets = UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: .zero)
        static let dateLabelViewSideSize: CGFloat = .zero
        
        static let mainImageViewInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        static let mainImageViewWidth: CGFloat = .zero
        
        static let smallDescriptionLabelInsets = UIEdgeInsets(top: 10, left: 16, bottom: 5, right: 16)
        static let smallDescriptionLabelSideSize: CGFloat = .zero
    }
    
    // MARK: - Public properties
    
    let mainImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let smallDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .postListText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Private properties
    
    private let favImageView: UIImageView = {
        let image = UIImage(systemName: Constants.flameFillImageName)
        let imageView = UIImageView()
        imageView.image = image ?? UIImage()
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    private let darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setMainImageViewContentMode()
    }
    
    //  MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = Constants.postCornerRadius
        self.layer.backgroundColor = UIColor.rowBackground.cgColor
        self.clipsToBounds = false
        DispatchQueue.main.async {
                    self.mainImageView.layer.masksToBounds = true
                    self.mainImageView.layer.cornerRadius = Constants.imageCornerRadius
                    self.mainImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func set(imageUrl: String?) {
        mainImageView.set(imageURL: imageUrl, isThumbnail: true)
    }
    
    func setVisibilityOfFavoriteImageView(posts: [Post], index: Int) {
        let id = posts[index].id
        let array = UserDefaults.favPosts ?? []
        favImageView.isHidden = !array.contains(id)
    }
    
    // MARK: - Private functions
    
    private func setupLayout() {
        
        addSubviews([smallDescriptionLabel, mainImageView])
        
        mainImageView.addSubviews([darkView, nameLabel, favImageView, dateLabel])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, constant: Constants.nameLabelWidthConstant),
            
            darkView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            darkView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            
            darkView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor),
            darkView.heightAnchor.constraint(equalTo: mainImageView.heightAnchor),
            
            mainImageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
                
        favImageView.anchor(top: mainImageView.topAnchor,
                            left: nil,
                            bottom: nil,
                            right: mainImageView.rightAnchor,
                            paddingTop: Constants.favImageViewInsets.top,
                            paddingLeft: Constants.favImageViewInsets.left,
                            paddingBottom: Constants.favImageViewInsets.bottom,
                            paddingRight: Constants.favImageViewInsets.right,
                            width: Constants.favImageViewSideSize,
                            height: Constants.favImageViewSideSize)
        
        dateLabel.anchor(top: nameLabel.bottomAnchor,
                         left: nil,
                         bottom: nil,
                         right: nil,
                         paddingTop: Constants.dateLabelViewInsets.top,
                         paddingLeft: Constants.dateLabelViewInsets.left,
                         paddingBottom: Constants.dateLabelViewInsets.bottom,
                         paddingRight: Constants.dateLabelViewInsets.right,
                         width: Constants.dateLabelViewSideSize,
                         height: Constants.dateLabelViewSideSize)
        
        mainImageView.anchor(top: topAnchor,
                             left: leftAnchor,
                             bottom: nil, right: rightAnchor,
                             paddingTop: Constants.mainImageViewInsets.top,
                             paddingLeft: Constants.mainImageViewInsets.left,
                             paddingBottom: Constants.mainImageViewInsets.bottom,
                             paddingRight: Constants.mainImageViewInsets.right,
                             width: Constants.mainImageViewWidth,
                             height: Constants.postListImageHeight)
        
        smallDescriptionLabel.anchor(top: mainImageView.bottomAnchor,
                                     left: leftAnchor,
                                     bottom: bottomAnchor,
                                     right: rightAnchor,
                                     paddingTop: Constants.smallDescriptionLabelInsets.top,
                                     paddingLeft: Constants.smallDescriptionLabelInsets.left,
                                     paddingBottom: Constants.smallDescriptionLabelInsets.bottom,
                                     paddingRight: Constants.smallDescriptionLabelInsets.right,
                                     width: Constants.smallDescriptionLabelSideSize,
                                     height: Constants.smallDescriptionLabelSideSize)

    }
    
    private func setMainImageViewContentMode() {
        mainImageView.contentMode = .scaleAspectFill
    }
    
}
