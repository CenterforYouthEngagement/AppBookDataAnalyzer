//
//  ViewCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation
import GRDB
import Regex

struct ViewCount: Analytic {
    
    let pageViewEventCode = 99
    let jobViewEventCode = 49
    
    var title: String = "View Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) = \(pageViewEventCode)
                """
                
                let allEvents = try Row.fetchCursor(db, sql: query)
                
                // expected page open/close description syntax for this page
                let regex = try Regex("a-\(appbook.id) p-\(pageNumber)$")
                
                let relevantEvents = allEvents.filter { row in
                    regex.isMatched(by: row[Database.EventLog.Column.description])
                }
                
                var count = 0
                
                while try relevantEvents.next() != nil {
                    count += 1
                }
                
                return String(count)
                
                
            case .job(let job):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) = \(jobViewEventCode)
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
