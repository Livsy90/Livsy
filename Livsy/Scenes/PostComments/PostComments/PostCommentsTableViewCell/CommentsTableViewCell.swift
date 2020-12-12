//
//  CommentsTableViewCell.swift
//  Livsy
//
//  Created by Artem on 05.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var postAuthorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        let selectedBackgroundView = UIView()
        let unselectedBackgroundView = UIView()
        unselectedBackgroundView.backgroundColor = .clear
        selectedBackgroundView.backgroundColor = UIColor.rowBackground.withAlphaComponent(0.4)
        self.selectedBackgroundView = selectedBackgroundView
        self.backgroundView = unselectedBackgroundView
        repliesLabel.textColor = .navBarTint
        dateLabel.textColor = .navBarTint
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func reuseIdentifier() -> String {
        return "CommentsTableViewCellID"
    }
    
    class func nibName() -> String {
        return "CommentsTableViewCell"
    }
    
    func config(comment: PostComment, isReplyButtonHidden: Bool, postAuthorName: String) {
        let repliesText = comment.replies.count == 1 ? Text.Comments.reply : Text.Comments.replies
        repliesLabel.text = "••• \(repliesText): \(comment.replies.count)"
        authorNameLabel.text = comment.authorName.pureString()
        authorNameLabel.textColor = UserDefaults.standard.username != authorNameLabel.text ? .postListText : .blueButton
        contentLabel.text = comment.content?.rendered?.pureString()
        repliesLabel.isHidden = isReplyButtonHidden || comment.replies.count == 0
        postAuthorImageView.isHidden = postAuthorName != authorNameLabel.text
        dateLabel.text = comment.date.getDate()?.formatToDateAndTimeStyle()
    }
    
}
