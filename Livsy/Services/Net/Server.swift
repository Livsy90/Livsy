//
//  Server.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

struct Server {
    static let urlString = "https://intentapp.ru/wp-json/"
    static func getBaseUrl(path: String) -> URL? {
        let url = "\(urlString)\(path)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? url
        return URL(string: encodedURL)
    }
}

//        var components = URLComponents()
//        components.scheme = API.scheme
//        components.host = API.host
//        components.path = path
//        components.queryItems = [
//           URLQueryItem(name: "", value: searchTerm),
//           URLQueryItem(name: "", value: format)
//        ]
//        return components.url!
