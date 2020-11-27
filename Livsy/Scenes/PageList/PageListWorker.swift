//
//  PageListWorker.swift
//  Livsy
//
//  Created by Artem on 26.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PageListWorkingLogic {
    func fetchPageList(completion: @escaping (Bodies.PostListAPI.Response?, CustomError?) -> ())
}

final class PageListWorker: PageListWorkingLogic {
    let net: NetService = NetService.sharedInstanse
    let netManager: NetManager = NetManager.sharedInstanse
    
    func fetchPageList(completion: @escaping (Bodies.PostListAPI.Response?, CustomError?) -> ()) {
        netManager.fetchPageList(completion: completion)
    }
    
}
