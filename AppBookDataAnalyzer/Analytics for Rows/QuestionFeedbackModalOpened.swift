//
//  QuestionFeedbackModalOpened.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//


import Foundation

struct QuestionFeedbackModalOpened: Analytic {
    
    let questionFeedbackModalOpenedEventCode = 66
    
    var title: String = "Question Feedback Modal Opened"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(questionFeedbackModalOpenedEventCode)
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
