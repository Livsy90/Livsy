//
//  Array+adds.swift
//  Livsy
//
//  Created by Artem on 15.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
    
}

