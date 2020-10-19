//
//  RegisterWorker.swift
//  Livsy
//
//  Created by Artem on 14.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//
import Foundation

final class RegisterWorker {
    let net = NetService.sharedInstanse
    
    func register(username: String, email: String, password: String, completion: @escaping (Bodies.RegisterAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.Register(username, email, password).get(path: API.postList)
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.RegisterAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
