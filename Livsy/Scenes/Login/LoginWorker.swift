//
//  LoginWorker.swift
//  Livsy
//
//  Created by Artem on 07.07.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class LoginWorker {
    let net: NetService = NetService.sharedInstanse
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, Error?) -> ()) {
        let request = Request.RequestType.Login(login, password).get(path: "jwt-auth/v1/token")
        net.getData(with: request) { (data, error) in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Bodies.LoginAPI.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
