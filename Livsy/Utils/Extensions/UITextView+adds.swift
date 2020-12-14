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
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>",formatStringWithYTVideo(text: htmlText, with: Float(rect?.size.width ?? 375)))
        
        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = resizeImageInHTMLString(attrStr: attrStr)
        self.textColor = color
    }
    
    private func resizeImageInHTMLString(attrStr: NSMutableAttributedString) -> NSMutableAttributedString {
        attrStr.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                let screenSize: CGRect = UIScreen.main.bounds
                if image.size.width > screenSize.width - 50 {
                    let newImage = image.resize(scaledToWidth: screenSize.width - 50)
                    let newAttribut = NSTextAttachment()
                    newAttribut.image = newImage
                    attrStr.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
                }
            }
        })
        return attrStr
    }
    
    private func formatStringWithYTVideo(text: String, with width: Float) -> String {
        let iframeTexts = matches(for: ".*iframe.*", in: text)
        var newText = text
        
        if iframeTexts.count > 0 {
            
            for iframeText in iframeTexts {
                let iframeId = matches(for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", in: iframeText);
                
                if iframeId.count > 0 {
                    
                    let imgString = "<a href='https://www.youtube.com/watch?v=\(iframeId[0])'><img src=\"https://img.youtube.com/vi/" + iframeId[0] + "/maxresdefault.jpg\" alt=\"\" width=\"\(width)\" /></a>"
                    
                    let htmlString = "<h5>•\(Text.Common.openVideo)\(imgString)</h5>"
                    
                    newText = newText.replacingOccurrences(of: iframeText, with: htmlString)
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
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}





