//
//  CustomTextView.swift
//  Livsy
//
//  Created by Artem on 25.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

final class CustomTextView: UITextView {

   override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {

   }
}
    
    
final class UITextViewFixed: UITextView {

    var didTappedOnAreaBesidesAttachment: (() -> Void)? = nil
    var didTappedOnAttachment: ((UIImage) -> Void)? = nil

    // A single tap won't move.
    private var isTouchMoved = false
    private var tappedImage: UIImage?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        isTouchMoved = true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 2 {
            let index = indexOfTap(recognizer: tapGestureRecognizer)
              if let _ = attributedText?.attribute(NSAttributedString.Key.attachment, at: index, effectiveRange: nil) as? NSTextAttachment {
                
                return false
            }
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapOnAttachment(touches.first!.location(in: self)) {
            guard let image = tappedImage else { return }
            didTappedOnAttachment?(image)
            return
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isTouchMoved &&
            !isTapOnAttachment(touches.first!.location(in: self)) &&
            selectedRange.length == 0 {
            didTappedOnAreaBesidesAttachment?()
        }
        
        isTouchMoved = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        // `UITextView` will cancel the touch then starting selection

        isTouchMoved = false
    }

    private func isTapOnAttachment(_ point: CGPoint) -> Bool {
        let range = NSRange(location: 0, length: attributedText.length)
        var found = false
        attributedText.enumerateAttribute(.attachment, in: range, options: []) { (value, effectiveRange, stop) in
            guard let attachment = value as? NSTextAttachment else {
                return
            }
            
            tappedImage = attachment.image
            let rect = layoutManager.boundingRect(forGlyphRange: effectiveRange, in: textContainer)
            if rect.contains(point) {
                found = true
                stop.pointee = true
            }
        }
        
        return found
    }
}
