//
//  Data+adds.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

extension Data {
    func toString() -> String {
        return String(decoding: self, as: UTF8.self)
    }
}
