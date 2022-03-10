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
    
    init?(path: URL) {
        
        self.title = path.lastPathComponent // the file name of the database
        
        let dbDestination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UUID().uuidString).sql")
        do {
            try FileManager.default.copyItem(at: path, to: dbDestination)
            self.pool = try DatabasePool(path: dbDestination.path)
        } catch {
            print("Error creating `DatabasePool`: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    
}
