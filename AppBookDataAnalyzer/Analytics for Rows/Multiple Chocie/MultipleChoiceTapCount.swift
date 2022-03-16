//
//  MultipleChoiceTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//

import GRDB
import Foundation

struct MultipleChoiceTapCount: Analytic {
    
    var title: String = "Multiple Choice - Number of Tapped Items"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT
                        \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.possibleAnswerId),
                        \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.isSelected)
                    FROM \(Database.MultipleChoiceStudentAnswer.tableName)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.questionId)
                        = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
                    ORDER BY
                        \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.questionId) ASC,
                        \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.possibleAnswerId) ASC,
                        \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.version) ASC

                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                var currentPossibleAnswer = 0
                
                // tracks the previous `is_selected` value of the colum. A change in this value denotes selection/deselection
                var previousIsSelectedState = false
                
                var tapCount = 0
                
                while let row = try rows.next() {
                    
                    let rowPossibleAnswer: Int = row[Database.MultipleChoiceStudentAnswer.Column.possibleAnswerId]
                    if rowPossibleAnswer != currentPossibleAnswer {
                        previousIsSelectedState = false // reset to unselected to prepare for the new possible answer
                        currentPossibleAnswer = rowPossibleAnswer
                    }
                    
                    let rowSelectionState: Bool = row[Database.MultipleChoiceStudentAnswer.Column.isSelected]
                    if rowSelectionState != previousIsSelectedState {
                        tapCount += 1
                        previousIsSelectedState = rowSelectionState
                    }
                    
                }
                
                return String(tapCount)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}

