//
//  TagsWorker.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol TagsWorkingLogic {
    func fetchTags(completion: @escaping (Bodies.TagsAPI.Response?, CustomError?) -> ())
}

final class TagsWorker: TagsWorkingLogic {
    
    private let net = NetService.sharedInstanse
    private let netManager = NetManager.sharedInstanse
    
    func fetchTags(completion: @escaping (Bodies.TagsAPI.Response?, CustomError?) -> ()) {
       // netManager.fetchTags(completion: completion)
    }
}
