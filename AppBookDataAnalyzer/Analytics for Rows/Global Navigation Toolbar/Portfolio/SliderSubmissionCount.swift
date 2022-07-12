//
//  SliderSubmissionCount.swift
//  AppBookDataAnalyzer
//
//  Created by Francis Furnelli on 3/29/22.
//

import Foundation
struct SliderSubmissionCount: Analytic {
    
    var title: String = "Slider Submission Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.SliderStudentAnswer.tableName)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.SliderStudentAnswer.tableName).\(Database.SliderStudentAnswer.Column.questionId)
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
