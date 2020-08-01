//
//  Server.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

struct Server {
    static let urlString = "https://livsy.me/wp-json/"
    static func getBaseUrl(path: String) -> URL? {
        return URL(string: urlString + path)
    }
}
