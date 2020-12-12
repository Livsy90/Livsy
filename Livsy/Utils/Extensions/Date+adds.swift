//
//  Date+adds.swift
//  Livsy
//
//  Created by Artem on 12.12.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

extension Date {
    func toString(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func formatToShortStyle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
