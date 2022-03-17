//
//  MultipleChoiceAttempts.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/15/22.
//

import GRDB
import Foundation

struct MultipleChoiceAttempts: Analytic {
    
    var title: String = "Multiple Choice - Attempts"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM (
                        SELECT *
                        FROM \(Database.MultipleChoiceStudentAnswer.tableName)
                        JOIN \(Database.QuestionPageJoin.tableName)
                        ON \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.questionId)
                            = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                        WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                            = \(pageNumber)
                        AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                            = \(appbook.id)
                        AND \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.isSubmitted)
                            = 1
                        GROUP BY \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.questionId),
                            \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.version)
                    )
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
