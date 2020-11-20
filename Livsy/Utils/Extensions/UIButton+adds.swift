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
                                   duration: 0.35,
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

extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
