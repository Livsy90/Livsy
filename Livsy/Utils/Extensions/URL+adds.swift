//
//  URL+adds.swift
//  Livsy
//
//  Created by Artem on 05.12.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
