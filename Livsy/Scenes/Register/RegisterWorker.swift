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
    let netManager: NetManager = NetManager.sharedInstanse
    
    func register(username: String, email: String, password: String, completion: @escaping (Bodies.RegisterAPI.Response?, CustomError?) -> ()) {
        netManager.register(username: username, email: email, password: password, completion: completion)
    }
    
}
