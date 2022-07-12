//
//  DragDropAttemptCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct DragDropAttemptCount: Analytic {
    
    var title: String = "Drag and Drop - Attempts"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT \(Database.Question.Column.latestVersion)
                    FROM \(Database.Question.tableName)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.Question.tableName).\(Database.Question.Column.id)
                        = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
                    AND \(Database.Question.Column.questionType) = 'dragDrop'
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
