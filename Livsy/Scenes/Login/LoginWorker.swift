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
    let netManager: NetManager = NetManager.sharedInstanse
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, Error?) -> ()) {
        netManager.login(login: login, password: password, completion: completion)
    }
    
}
