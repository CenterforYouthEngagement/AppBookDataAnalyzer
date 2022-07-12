//
//  SwipeableChanges.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import GRDB
import Foundation

struct SwipeableChanges: Analytic {
    
    var title: String = "Swipe - Changes"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT
                        \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.swipeableId),
                        \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.response)
                    FROM \(Database.SwipeableStudentAnswer.tableName)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                        = \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.questionId)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
                    ORDER BY
                        \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.swipeableId) ASC,
                        \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.timestamp) ASC
                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                var currentSwipeableId = 0
                
                // tracks the previous `response` value of the column. A change in this value denotes a change in swiped direction
                var previousIsRightSwipeState = false
                
                var changeCount = 0
                
                while let row = try rows.next() {
                    
                    let rowSwipeableId: Int = row[Database.SwipeableStudentAnswer.Column.swipeableId]
                    let rowIsRightSwipeState: Bool = row[Database.SwipeableStudentAnswer.Column.response]
                    
                    if rowSwipeableId != currentSwipeableId {
                        previousIsRightSwipeState = rowIsRightSwipeState // set to initial swiped state
                        currentSwipeableId = rowSwipeableId
                    }
                    
                    if rowIsRightSwipeState != previousIsRightSwipeState {
                        changeCount += 1
                        previousIsRightSwipeState = rowIsRightSwipeState
                    }
                    
                }
                
                return String(changeCount)
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}
