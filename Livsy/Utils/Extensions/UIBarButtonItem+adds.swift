//
//  UIBarButtonItem+adds.swift
//  Livsy
//
//  Created by Artem on 14.12.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = .zero, andColor color: UIColor = .white, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 12)
    {
        badgeLayer?.removeFromSuperlayer()
        
        if (text == nil || text == "") {
            return
        }
        
        addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
    }
    
    private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = .white, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 12)
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        var font = UIFont.systemFont(ofSize: fontSize)
        
        font = .monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let badge = CAShapeLayer()
        
        let height = badgeSize.height;
        var width = badgeSize.width + 2
        
        if (width < height) {
            width = height
        }
        
        let x = view.frame.width - width + offset.x
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))
        
        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        let label = CATextLayer()
        label.string = text
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.font = font
        label.fontSize = font.pointSize
        
        label.frame = badgeFrame
        label.foregroundColor = filled ? UIColor.darkText.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    
}

