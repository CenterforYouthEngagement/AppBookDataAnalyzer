//
//  Database+Job.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation
import AppBookAnalyticEvents

extension Database {
    
    struct Job {
        
        static let tableName = "job"
        
        struct Column {
            static let id = "id"
            static let videoModalId = "video_modal_id"
        }
        
        static func analyze(event: AppBookAnalyticEvent, database: Database, textbookMaterial: TextbookMaterial) async -> String? {
            
            try? await database.pool.read { db in
                
                switch textbookMaterial {
                    
                case .page(let appbook, let pageNumber):
                    
                    return try Database.count(events: [event], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                    
                    
                case .job(let job):
                    
                    let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) = \(event.code)
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
