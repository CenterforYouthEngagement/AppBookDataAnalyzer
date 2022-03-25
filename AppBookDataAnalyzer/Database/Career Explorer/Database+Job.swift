//
//  Database+Job.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

extension Database {
    
    struct Job {
        
        static let tableName = "job"
        
        struct Column {
            static let id = "id"
            static let videoModalId = "video_modal_id"
        }
        
        static func analyze(eventCode: Int, database: Database, textbookMaterial: TextbookMaterial) async -> String? {
            
            try? await database.pool.read { db in
                
                switch textbookMaterial {
                    
                case .page(let appbook, let pageNumber):
                    
                    let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(eventCode)
                """
                    
                    guard let count = try Int.fetchOne(db, sql: query) else {
                        return nil
                    }
                    
                    return String(count)
                    
                    
                case .job(let job):
                    
                    let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) = \(eventCode)
                    AND \(Database.EventLog.Column.contextId) = \(job.id)
                """
                    
                    guard let count = try Int.fetchOne(db, sql: query) else {
                        return nil
                    }
                    
                    return String(count)
                    
                }
                
                
            }
            
        }
        
    }
    
}
