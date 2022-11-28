//
//  CommentInputtextView.swift
//  Livsy
//
//  Created by Artem on 06.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

final class CommentInputTextView: UITextView, UITextViewDelegate {
    
    var textInputCompletion: ((Bool) -> Void)?
    var textInputLoginCompletion: (() -> Void)?
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = Text.Comments.enterComment
        label.textColor = .lightGray
        return label
    }()
    
    private var maxHeight: CGFloat = 200
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height > maxHeight {
            size.height = maxHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        return size
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
        textInputCompletion?(self.text.isEmpty)
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if UserDefaults.standard.token == "" {
            textInputLoginCompletion?()
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
