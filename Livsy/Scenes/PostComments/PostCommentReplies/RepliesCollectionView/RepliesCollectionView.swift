//
//  RepliesCollectionView.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class RepliesCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var comments = [PostComment]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .listBackground
        delegate = self
        dataSource = self
        register(RepliesCollectionViewCell.self, forCellWithReuseIdentifier: RepliesCollectionViewCell.reuseId)
        
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
        let commentCell = dequeueReusableCell(withReuseIdentifier: RepliesCollectionViewCell.reuseId, for: indexPath) as! RepliesCollectionViewCell
        guard let content = comments[safe: indexPath.item]?.content?.rendered else { return UICollectionViewCell()}
        
        commentCell.isParent = comments[indexPath.item].parent == 0 ? true : false
        commentCell.nameLabel.text = comments[indexPath.item].authorName
        commentCell.content.text = String(htmlEncodedString: content)
        
        return commentCell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
