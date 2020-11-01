//
//  CommentInputAccessoryView.swift
//  Livsy
//
//  Created by Artem on 06.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
        submitButton.isEnabled = false
    }
    
    func enableButton() {
        if commentTextView.text.count > 0 {
            submitButton.isEnabled = true
        }
    }
    
    private let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.layer.cornerRadius = 18
        tv.backgroundColor = UIColor.init(named: "PostBackground")
        tv.textColor = UIColor.init(named: "PostText")
        tv.tintColor = UIColor.init(named: "NavBarTint")
        tv.layer.borderWidth = 1
        tv.layer.borderColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return tv
    }()
    
    private let submitButton: UIButton = {
        let sb = UIButton(type: .system)
       // sb.setTitle("Submit", for: .normal)
        sb.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
       // sb.setTitleColor(UIColor.init(named: "PostText"), for: .normal)
       // sb.setTitleColor(.gray, for: .disabled)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        sb.isEnabled = false
        sb.tintColor = .blueButton
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = UIColor.init(named: "InputAC")
        
        addSubview(submitButton)
        submitButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        submitButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
        
        commentTextView.textInputCompletion = { [weak self] (isEmpty) in
            guard let self = self else { return }
            self.submitButton.isEnabled = !isEmpty
        }
            
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = .listBackground
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    @objc func handleSubmit() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didSubmit(for: commentText)
        submitButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
