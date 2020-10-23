//
//  SplashWorker.swift
//  Livsy
//
//  Created by Artem on 23.09.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class SplashWorker {
    
    let net: NetService = NetService.sharedInstanse
    let netManager: NetManager = NetManager.sharedInstanse
    
    func login(login: String, password: String, completion: @escaping (Bodies.LoginAPI.Response?, CustomError?) -> ()) {
        netManager.login(login: login, password: password, completion: completion)
    }
    
}
