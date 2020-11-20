//
//  FavPostsCell.swift
//  Livsy
//
//  Created by Artem on 09.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class FavPostsCell: UITableViewCell {
    
   var loginCompletion: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .titleGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainImageView: WebImageView = {
        let v = WebImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.mainImageView.setRounded()
        }
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .rowBackground
        contentView.addSubview(mainImageView)
        mainImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.addSubview(titleLabel)
        mainImageView.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: titleLabel.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 50, height: 50)
        titleLabel.anchor(top: contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 30, paddingRight: 10, width: 0, height: 0)
    }
    
    func config(post: Post) {
        mainImageView.set(imageURL: post.imgURL)
        titleLabel.text = post.title?.rendered
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
