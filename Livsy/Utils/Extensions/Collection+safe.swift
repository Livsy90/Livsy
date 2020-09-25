//
//  Collection+safe.swift
//  Livsy
//
//  Created by Artem on 01.08.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

