//
//  DragDropPositionChanges.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct DragDropPositionChanges: Analytic {
    
    var title: String = "Drag and Drop - Position Changes"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.DragDropStudentAnswer.tableName)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.DragDropStudentAnswer.tableName).\(Database.DragDropStudentAnswer.Column.id)
                        = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
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
