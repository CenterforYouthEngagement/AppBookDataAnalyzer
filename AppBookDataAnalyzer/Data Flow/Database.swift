//
//  Database.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import GRDB

// TODO - need to decide if we want to use async or sync processing
struct Database {
    
    let pool: DatabasePool
    
    init?(path: String) {
        do {
            self.pool = try DatabasePool(path: path)
        } catch {
            print("Error creating `DatabasePool`: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    
}
