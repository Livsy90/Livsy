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
//        var components = URLComponents()
//        components.scheme = API.scheme
//        components.host = API.host
//        components.path = path
//        components.queryItems = [
//           URLQueryItem(name: "", value: searchTerm),
//           URLQueryItem(name: "", value: format)
//        ]
//        return components.url!
       return URL(string: urlString + path)
    }
}
