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
    var loadMoreCompletion: ((Bool) -> Void)?
    let footerView = UIActivityIndicatorView(style: .medium)
    
     init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        footerView.color = .darkGray
        footerView.hidesWhenStopped = true
        backgroundColor = UIColor.init(named: "PostListBackground")
        delegate = self
        dataSource = self
        register(PostListCollectionViewCell.self, forCellWithReuseIdentifier: PostListCollectionViewCell.reuseId)
        register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
                (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: bounds.width, height: 50)
        
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
                footer.addSubview(footerView)
                footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
                return footer
            }
            return UICollectionReusableView()
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
                loadMoreCompletion?(true)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
