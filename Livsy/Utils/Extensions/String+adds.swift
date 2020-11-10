//
//  String+adds.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

//extension String {
//
//    init?(htmlEncodedString: String) {
//
//        guard let data = htmlEncodedString.data(using: .utf8) else {
//            return nil
//        }
//
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//            .documentType: NSAttributedString.DocumentType.html,
//            .characterEncoding: String.Encoding.utf8.rawValue
//        ]
//
//        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
//            return nil
//        }
//
//        self.init(attributedString.string)
//
//    }
//
//}

extension String {
    func convertToAttributedFromHTML() -> NSAttributedString? {
        var attributedText: NSAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
            
        }
        return attributedText
    }
    
    func removeHTMLTags() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func handleHTMLEllipsel() -> String {
        return replacingOccurrences(of: "&#8230;", with: "...", options: .regularExpression, range: nil)
    }
    
    func handleHTMLDots() -> String {
        return replacingOccurrences(of: "&#46;", with: ".", options: .regularExpression, range: nil)
    }
    
    func handeLaquo() -> String {
        return replacingOccurrences(of: "&#171;", with: "«", options: .regularExpression, range: nil)
    }
    
    func handeRaquo() -> String {
        return replacingOccurrences(of: "&#187;", with: "»", options: .regularExpression, range: nil)
    }
    
    func pureString() -> String {
        return removeHTMLTags().handleHTMLEllipsel().handleHTMLDots() //.handeRaquo().handeLaquo()
    }
    
}
