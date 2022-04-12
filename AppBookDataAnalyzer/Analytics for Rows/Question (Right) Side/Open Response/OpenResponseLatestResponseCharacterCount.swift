//
//  OpenResponseLatestResponseCharacterCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 4/6/22.
//

import Foundation
import GRDB
import AppBookAnalyticEvents

struct OpenResponseLatestResponseCharacterCount: Analytic {
    
    var title: String = "Open Response - Latest Response Character Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT \(Database.OpenResponseStudentAnswer.Column.answer)
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
                    ORDER BY \(Database.EventLog.Column.timestamp) DESC
                    LIMIT 1
                """
                
                guard let latestResponse = try String.fetchOne(db, sql: query) else {
                    return nil
                }
                
                return String(latestResponse.count)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}
