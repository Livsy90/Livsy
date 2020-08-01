//
//  NetService.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

class NetService {
    static let sharedInstanse: NetService = NetService()
    private let queue = DispatchQueue(label: "NetQueue", qos: .utility)
    func getData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCredentialStorage = nil
        let session = URLSession(configuration: .default)
        self.queue.async {
            session.dataTask(with: request) {(data, response, error) in
                DispatchQueue.main.async {
                    completion(data, error)
                }
            } .resume()
        }
    }
}
