//
//  OpenResponseAttempts.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation
import AppBookAnalyticEvents

struct OpenResponseAttempts: Analytic {
    
    var title: String = "Open Response - Attempts"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.OpenResponseStudentAnswer.tableName)
                    JOIN \(Database.EventLog.tableName)
                    ON \(Database.EventLog.tableName).\(Database.EventLog.Column.contextId)
                        = \(Database.OpenResponseStudentAnswer.tableName).\(Database.OpenResponseStudentAnswer.Column.id)
                    WHERE \(Database.EventLog.tableName).\(Database.EventLog.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.EventLog.tableName).\(Database.EventLog.Column.appbookId)
                        = \(appbook.id)
                    AND \(Database.EventLog.Column.code)
                        = \(AppBookAnalyticEvent.openResponseAnswerSubmitted.code)
                """
                
                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
                }
                
                return String(count)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}
