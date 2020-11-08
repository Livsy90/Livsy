//
//  ProfileWorker.swift
//  Livsy
//
//  Created by Artem on 30.10.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class ProfileWorker {
    
    private let net = NetService.sharedInstanse
    private let netManager = NetManager.sharedInstanse
    
    func fetchUserComments(completion: @escaping (Bodies.PostCommentsAPI.Response?, Error?) -> ()) {
        netManager.fetchUserComments(completion: completion)
    }
    
}
