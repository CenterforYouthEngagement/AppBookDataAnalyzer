//
//  Database.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import GRDB
import Foundation

// TODO - need to decide if we want to use async or sync processing
struct Database {
    
    let pool: DatabasePool
    
    let title: String
    
    init?(path: String) {
        
        self.title = URL(fileURLWithPath: path).lastPathComponent // the file name of the database
        
        do {
            self.pool = try DatabasePool(path: path)
        } catch {
            print("Error creating `DatabasePool`: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    
}
