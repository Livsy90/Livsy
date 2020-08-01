//
//  PostCommentsCollectionView.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class PostCommentsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var comments = [PostComment]()
    var cellTappedCompletion: ((PostComment, [PostComment]) -> Void)?
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        delegate = self
        dataSource = self
        register(PostCommentsCollectionViewCell.self, forCellWithReuseIdentifier: PostCommentsCollectionViewCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 70, right: 10)
        alwaysBounceVertical = true
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func set(comments: [PostComment]) {
        self.comments = comments
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100 // Approximate height of cell
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let commentCell = dequeueReusableCell(withReuseIdentifier: PostCommentsCollectionViewCell.reuseId, for: indexPath) as! PostCommentsCollectionViewCell
        let repliesCount = comments[indexPath.row].replies.count
        
        if repliesCount > 0 {
            commentCell.repliesLabel.text = "Show replies (\(repliesCount))"
        } else {
            commentCell.repliesLabel.text = "Reply"
        }
        
        commentCell.nameLabel.text = comments[indexPath.row].authorName
        guard let content = comments[indexPath.row].content?.rendered else { return UICollectionViewCell()}
        commentCell.content.text = String(htmlEncodedString: content)
        
        return commentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTappedCompletion?(comments[indexPath.row], comments[indexPath.row].replies)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
