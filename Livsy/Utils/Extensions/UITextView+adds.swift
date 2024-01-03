//
//  UITextView+adds.swift
//  Livsy
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UITextView {
    
    func setHTMLFromString(htmlText: String, color: UIColor) {
        let rect = self.window?.frame
        let modifiedFont = String(
            format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>",
            formatStringWithYTVideo(text: htmlText, with: Float(rect?.size.width ?? 375))
        )
        
        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        self.attributedText = configured(attrStr: attrStr)
        self.textColor = color
    }
    
    private func configured(attrStr: NSMutableAttributedString) -> NSMutableAttributedString {
        attrStr.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                let screenSize: CGRect = UIScreen.main.bounds
                let newImage = image.resize(scaledToWidth: screenSize.width - 50)
                let newAttribut = NSTextAttachment()
                let filename = attachement.fileWrapper?.preferredFilename ?? ""
                
                if filename.contains("maxresdefault.jpg") {
                    let overlayed = newImage.withPlayButton()
                    newAttribut.image = overlayed
                } else {
                    newAttribut.image = newImage
                }
                
                attrStr.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
            }
        })
        return attrStr
    }
    
    private func formatStringWithYTVideo(text: String, with width: Float) -> String {
        let iframeTexts = matches(for: ".*iframe.*", in: text)
        var newText = text
        
        if !iframeTexts.isEmpty {
            iframeTexts.forEach { iframeText in
                let iframeId = matches(for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", in: iframeText);
                
                if !iframeId.isEmpty {
                    let imgString = """
                    <a href='https://www.youtube.com/watch?v=\(iframeId[0])'><img src="https://img.youtube.com/vi/\(iframeId[0])/maxresdefault.jpg" alt="" width="\(width)"/></a>
                    """
                    newText = newText.replacingOccurrences(of: iframeText, with: imgString)
                }
            }
        }
        
        return newText
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex,  options: .caseInsensitive)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
        #if DEBUG
            print("invalid regex: \(error.localizedDescription)")
        #endif
            return []
        }
    }
    
}

extension UITextView {
    func indexOfTap(recognizer: UITapGestureRecognizer) -> Int {
        var location: CGPoint = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return charIndex
    }
    
}

fileprivate extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

fileprivate extension UIImage {
    func withPlayButton() -> UIImage {
        let bgimg = self
        let bgimgview = UIImageView(image: bgimg)
        bgimgview.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let frontimg = UIImage(named: "play-icon")
        let frontimgview = UIImageView(image: frontimg)
        frontimgview.frame = CGRect(x: 150, y: 300, width: 100, height: 100)
        frontimgview.center = bgimgview.center
        frontimgview.alpha = 0.7

        bgimgview.addSubview(frontimgview)
        
        return bgimgview.asImage()
    }
}
