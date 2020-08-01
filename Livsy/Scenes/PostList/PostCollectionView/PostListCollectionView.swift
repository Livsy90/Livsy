//
//  PostLisCollectionView.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class PostListCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cells = [Post]()
    var isStopRefreshing = false
    var fetchIdCompletion: ((Int) -> Void)?
    var loadMoreCompletion: (() -> Void)?
    
     init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = #colorLiteral(red: 1, green: 0.9347417841, blue: 0.848009174, alpha: 1)
        delegate = self
        dataSource = self
        register(PostListCollectionViewCell.self, forCellWithReuseIdentifier: PostListCollectionViewCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.postListMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        alwaysBounceVertical = true
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func set(cells: [Post]) {
        self.cells = cells
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PostListCollectionViewCell.reuseId, for: indexPath) as! PostListCollectionViewCell
        cell.set(imageUrl: cells[indexPath.row].images?.medium)
        let description = cells[indexPath.row].excerpt?.rendered
        cell.nameLabel.text = cells[indexPath.row].title?.rendered
        cell.smallDescriptionLabel.text = String(htmlEncodedString: description ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.postListItemWidth, height: frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchIdCompletion?(cells[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch isStopRefreshing {
        case true:
            break
        default:
            if indexPath.row == cells.count - 1 {
                loadMoreCompletion?()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
