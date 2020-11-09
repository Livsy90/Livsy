//
//  UIButton+adds.swift
//  Livsy
//
//  Created by Artem on 09.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UIButton {

    func setImageWithAnimation(_ image: UIImage?, animated: Bool) {
        switch animated {
        case true:
            UIView.transition(with: self,
                                   duration: 0.2,
                                   options: .transitionFlipFromRight,
                                   animations: {
                                    self.setImage(image, for: .normal)
                                   },
                                   completion: nil)
        default:
            self.setImage(image, for: .normal)
        }
    }
    
}
