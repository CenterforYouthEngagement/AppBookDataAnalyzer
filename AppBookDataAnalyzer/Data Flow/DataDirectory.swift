//
//  DataDirectory.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

/// Handles the logic for processing the data stored on an iPad. Each iPad has 1 data directory. However, multiple student's data can be stored on 1 iPad.
struct DataDirectory {
    
    let documentsDirectory: URL
    
    /// Expects a documents directory export from a student's iPad. This is the folder exported from the iPad to AWS S3.
    init(documentsDirectory: URL) {
        self.documentsDirectory = documentsDirectory
    }
    
    /// The databases (plural since multiple students could be using the same iPad) stored in this data directory
    var databases: [Database] {
        
        let userDatabasesFolderName = "user_databases"
        
        let datbasesDirectory = documentsDirectory.appendingPathComponent(userDatabasesFolderName)
        
        guard FileManager.default.fileExists(atPath: datbasesDirectory.path) else {
            print("Looking for directory `/\(userDatabasesFolderName)` but couldn't find at the path provided: \(documentsDirectory.path)")
            return []
        }
        
        guard let databases = try? FileManager.default.contentsOfDirectory(atPath: datbasesDirectory.path) else {
            print("Couldn't find any databases at the path provided: \(datbasesDirectory.path)")
            return []
        }
        
        return databases.compactMap(Database.init(path:))
        
    }
    
}
