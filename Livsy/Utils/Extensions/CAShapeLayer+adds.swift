//
//  CAShapeLayer+adds.swift
//  Livsy
//
//  Created by Artem on 14.12.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
    
}
