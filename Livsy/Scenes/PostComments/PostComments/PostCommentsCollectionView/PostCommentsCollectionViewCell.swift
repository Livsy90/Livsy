//
//  PostCommentsCollectionViewCell.swift
//  Livsy
//
//  Created by Artem on 29.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class PostCommentsCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PostCommentsCollectionViewCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .authorName
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repliesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .blueButton
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .commentBody
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(content)
        addSubview(repliesLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            content.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            content.bottomAnchor.constraint(equalTo: repliesLabel.topAnchor, constant: -10),
            
            repliesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            repliesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            repliesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.rowBackground.cgColor
        self.clipsToBounds = false
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        nameLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        content.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        repliesLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
