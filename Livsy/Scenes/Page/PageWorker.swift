//
//  PageWorker.swift
//  Livsy
//
//  Created by Artem on 27.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PageWorkingLogic {
    func fetchPage(id: Int, completion: @escaping (Bodies.PostPageAPI.Response?, CustomError?) -> ()) 
}

final class PageWorker: PageWorkingLogic {
    
    let net: NetService = NetService.sharedInstanse
    let netManager: NetManager = NetManager.sharedInstanse
    
    func fetchPage(id: Int, completion: @escaping (Bodies.PostPageAPI.Response?, CustomError?) -> ()) {
        netManager.fetchPage(id: id, completion: completion)
    }
    
}
