//
//  CustomError.swift
//  Livsy
//
//  Created by Artem on 23.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct CustomError: Codable {
    var code: String
    var message: String
    var data: ErrorData
}

struct ErrorData: Codable {
    var status: Int
}
