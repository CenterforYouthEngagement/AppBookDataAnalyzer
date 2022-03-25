//
//  JobTypicalTasksModalOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobTypicalTasksModalOpenCount: Analytic {
    
    let eventCode = 43
    
    var title: String = "Job - Typical Tasks Modal Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
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
