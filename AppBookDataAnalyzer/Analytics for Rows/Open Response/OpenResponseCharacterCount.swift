//
//  OpenResponseCharacterCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import GRDB
import Foundation

struct OpenResponseCharacterCount: Analytic {
    
    var title: String = "Open Response - Character Count"
    
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

                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                var characterCount = 0
                
                while let row = try rows.next() {
                    let answer: String = row[Database.OpenResponseStudentAnswer.Column.answer]
                    characterCount += answer.count
                }
                
                return String(characterCount)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}
