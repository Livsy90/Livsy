//
//  PostLisCollectionView.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class PostListCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Constants
    
    private enum Constants {
        static let width: CGFloat = InterfaceIdiom.isIpad ? (UIScreen.main.bounds.width / 3) : UIScreen.main.bounds.width
        static let topDistanceToView: CGFloat = 20
        static let bottomDistanceToView: CGFloat = 20
        static let leftDistanceToView: CGFloat = 20
        static let rightDistanceToView: CGFloat = 20
        static let postListMinimumLineSpacing: CGFloat = 20
        static let postListItemWHeight: CGFloat = 260
        static let postListItemWidth = (width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.postListMinimumLineSpacing / 2))
        static let footerHeight: CGFloat = 50
        static let flameImageName = "flame"
        static let flameFillImageName = "flame.fill"
        static let xmarkImageName = "xmark.circle.fill"
        static let favoritePostsKey = "favPosts"
    }
    
    // MARK: - Properties
    
    var cells = [Post]()
    var isStopRefreshing = false
    var fetchPostCompletion: ((Post) -> Void)?
    var loadMoreCompletion: ((Bool) -> Void)?
    let footerView = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Init
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.postListMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.topDistanceToView, left: Constants.leftDistanceToView, bottom: Constants.bottomDistanceToView, right: Constants.rightDistanceToView)
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .postListBackground
        footerView.color = .darkGray
        footerView.hidesWhenStopped = true
        delegate = self
        dataSource = self
        register(PostListCollectionViewCell.self, forCellWithReuseIdentifier: PostListCollectionViewCell.reuseIdentifier)
        register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterView.reuseIdentifier)
        (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: bounds.width, height: Constants.footerHeight)
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    // MARK: - Functions
    
    func set(cells: [Post]) {
        self.cells = cells
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterView.reuseIdentifier, for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: Constants.footerHeight)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PostListCollectionViewCell.reuseIdentifier, for: indexPath) as! PostListCollectionViewCell
        cell.set(imageUrl: cells[indexPath.row].imgURL)
        let description = cells[indexPath.row].excerpt?.rendered?.pureString()
        let title = cells[indexPath.row].title?.rendered.pureString()
        let date = cells[indexPath.row].date.getDate()?.formatToShortStyle()
        cell.nameLabel.text = title
        cell.smallDescriptionLabel.text = description
        cell.dateLabel.text = date
        cell.setVisibilityOfFavoriteImageView(posts: cells, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.postListItemWidth, height: Constants.postListItemWHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchPostCompletion?(cells[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isStopRefreshing {
            if indexPath.row == cells.count - 1 {
                loadMoreCompletion?(true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            let id = self.cells[indexPath.row].id
            var array = UserDefaults.favPosts ?? []
            var action = UIAction(title: "", image: UIImage(systemName: Constants.flameImageName)) {_ in }
            
            switch array.contains(id) {
            case true:
                action = UIAction(title: Text.Post.removeFF, image: UIImage(systemName: Constants.flameImageName)) {_ in
                    array = array.filter { $0 != id }
                    UserDefaults.standard.set(array, forKey: Constants.favoritePostsKey)
                    self.reloadItems(at: [indexPath])
                }
            case false:
                action = UIAction(title: Text.Post.addTF, image: UIImage(systemName: Constants.flameFillImageName)) {_ in
                    array.append(id)
                    UserDefaults.standard.set(array, forKey: Constants.favoritePostsKey)
                    self.reloadItems(at: [indexPath])
                }
                
            }
            return UIMenu(title: "", image: nil, identifier: nil, children: [action])
        }
        
        return configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
