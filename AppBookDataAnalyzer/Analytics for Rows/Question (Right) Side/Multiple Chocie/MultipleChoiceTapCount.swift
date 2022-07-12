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
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let questionsOnPageQuery = """
                    SELECT
                        \(Database.QuestionPageJoin.Column.questionId),
                        \(Database.MultipleChoiceMultipleAnswersAllowed.Column.maxSelectedAnswersAllowed)
                    FROM \(Database.QuestionPageJoin.tableName)
                    JOIN \(Database.Question.tableName)
                    ON \(Database.Question.tableName).\(Database.Question.Column.id)
                        = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                    LEFT JOIN \(Database.MultipleChoiceMultipleAnswersAllowed.tableName)
                    ON \(Database.MultipleChoiceMultipleAnswersAllowed.Column.questionId)
                        = \(Database.Question.tableName).\(Database.Question.Column.id)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
                    AND \(Database.Question.Column.questionType) = 'multipleChoice'
                """
                
                let questionRows = try Row.fetchCursor(db, sql: questionsOnPageQuery)
                
                // keeps track of the total number of possible answers tapped (selected or deselected) on this page
                var tapCount = 0
                
                // for all the multiple choice questions on this page
                while let questionRow = try questionRows.next() {
                    
                    let questionId: Database.Question.Id = questionRow[Database.QuestionPageJoin.Column.questionId]
                    let maxSelectionsAllowed: Int? = questionRow[Database.MultipleChoiceMultipleAnswersAllowed.Column.maxSelectedAnswersAllowed]
                    
                    // if it doesn't allow multiple selection, the number of versions is the number of taps
                    if maxSelectionsAllowed == nil {
                        
                        let versionCountQuery = """
                            SELECT MAX(\(Database.MultipleChoiceStudentAnswer.Column.version))
                            FROM \(Database.MultipleChoiceStudentAnswer.tableName)
                            WHERE \(Database.MultipleChoiceStudentAnswer.Column.questionId) = \(questionId)
                        """
                        
                        guard let versionCount = try Int.fetchOne(db, sql: versionCountQuery) else {
                            continue
                        }
                        
                        tapCount += versionCount
                        
                    } else { // if it allows multiple selection, need to compute the difference between each version for each answer to know if a tap occured
                        
                        let multipleSelectionPossibleQuery = """
                            SELECT
                                \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.possibleAnswerId),
                                \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.isSelected)
                            FROM \(Database.MultipleChoiceStudentAnswer.tableName)
                            WHERE \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.questionId)
                                = \(questionId)
                            ORDER BY
                                \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.possibleAnswerId) ASC,
                                \(Database.MultipleChoiceStudentAnswer.tableName).\(Database.MultipleChoiceStudentAnswer.Column.version) ASC
                        """
                        
                        let rows = try Row.fetchCursor(db, sql: multipleSelectionPossibleQuery)
                        
                        var currentPossibleAnswer = 0
                        
                        // tracks the previous `is_selected` value of the column. A change in this value denotes selection/deselection
                        var previousIsSelectedState = false
                        
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
                        
                    }
                    
                }
                
                return String(tapCount)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}

