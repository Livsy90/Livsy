//
//  UICollectionView+adds.swift
//  Livsy
//
//  Created by Artem on 10.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UICollectionView {
    func softReload() {
        UIView.transition(with: self,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
}
