//
//  Database.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

typealias DatabaseQueue = Void // TODO - to be replaced by `FMDatabaseQueue`

struct Database {
    
    let queue: DatabaseQueue
    
    init(path: String) {
        self.queue = () // TODO - create `FMDatbaseQueue` from path
    }
    
    func run(transaction: (DatabaseQueue) -> Void) {
        // TODO - call `queue.inDatabase { database in ... }`
    }
    
}
