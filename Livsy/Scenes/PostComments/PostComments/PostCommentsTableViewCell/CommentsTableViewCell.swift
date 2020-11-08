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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedBackgroundView = UIView()
        let unselectedBackgroundView = UIView()
        unselectedBackgroundView.backgroundColor = .rowBackground
        selectedBackgroundView.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        self.selectedBackgroundView = selectedBackgroundView
        self.backgroundView = unselectedBackgroundView
        repliesLabel.textColor = .blueButton
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
    
    func config(comment: PostComment, isReplyButtonHidden: Bool) {
        let repliesText = comment.replies.count == 1 ? "reply" : "replies"
        repliesLabel.text = "••• \(comment.replies.count) \(repliesText)"
        authorNameLabel.text = comment.authorName.pureString()
        contentLabel.text = comment.content?.rendered?.pureString()
        repliesLabel.isHidden = isReplyButtonHidden || comment.replies.count == 0
        
    }
    
}
