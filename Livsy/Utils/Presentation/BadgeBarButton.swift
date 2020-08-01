//
//  BadgeBarButton.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

/// Can show Badge label with number
final class BadgeBarButton: UIBarButtonItem {
  
  // MARK: - Private Properties
  
  /// Label for adding as subview
  private var badgeLabel: UILabel?
  
  /// Width and height for badge label
    private let badgeLabelBaseSize: CGFloat = 14.5
  
  
  // MARK: - Public Methods
  
  /// Add badge over bar button
  ///
  /// - Parameter number: digit in label
  func addBadge(number: String) {
    guard let view = value(forKey: "view") as? UIView else { return }
    let badge = createLabel(parentSize: view.frame, number: number)
    
    removeBadge()
    view.addSubview(badge)
    badgeLabel = badge
  }
  
  /// Remove badge label from bar button
  func removeBadge() {
    badgeLabel?.removeFromSuperview()
    badgeLabel = nil
  }
  
  // MARK: - Private Methods
  
  private func createLabel(parentSize: CGRect, number: String) -> UILabel {
    let labelWidth = badgeLabelBaseSize + CGFloat(number.count)
    let labelFrame = CGRect(x: parentSize.width - labelWidth - 1, y: 4, width: labelWidth, height: badgeLabelBaseSize)
    let label = UILabel(frame: labelFrame)
    
    label.layer.borderColor = UIColor.clear.cgColor
    label.layer.borderWidth = 2
    label.layer.cornerRadius = badgeLabelBaseSize / 2
    label.textAlignment = .center
    label.layer.masksToBounds = true
    label.font = .systemFont(ofSize: 11, weight: .semibold)
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 1, green: 0.5907847247, blue: 0.001635324071, alpha: 1)
    label.text = number
    
    return label
  }
  
}
