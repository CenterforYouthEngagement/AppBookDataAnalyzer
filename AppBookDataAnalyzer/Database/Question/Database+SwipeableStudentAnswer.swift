//
//  Database+SwipeableStudentAnswer.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

extension Database {
    
    struct SwipeableStudentAnswer {
        static let tableName = "swipeable_student_answer"
        struct Column {
            static let id = "id"
            static let swipeableId = "swipeable_id"
            
            // Bool, true is right swipe, false is left swipe
            static let response = "response"
            static let questionId = "question_id"
            static let timestamp = "attempt_time"
        }
        
        static func generateRoundOneQuery(isRightSwipe: Bool, appbookId: AppBook.ID, pageNumber: Int) -> String {
            
            """
            SELECT COUNT(*)
            FROM (
                SELECT
                    \(Database.SwipeableStudentAnswer.Column.swipeableId),
                    MIN(\(Database.SwipeableStudentAnswer.Column.timestamp)),
                    \(Database.SwipeableStudentAnswer.Column.response)
                FROM \(Database.SwipeableStudentAnswer.tableName)
                JOIN \(Database.QuestionPageJoin.tableName)
                ON \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                    = \(Database.SwipeableStudentAnswer.tableName).\(Database.SwipeableStudentAnswer.Column.questionId)
                WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                    = \(pageNumber)
                AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                    = \(appbookId)
                GROUP BY \(Database.SwipeableStudentAnswer.Column.swipeableId)
            )
            WHERE \(Database.SwipeableStudentAnswer.Column.response) = \(isRightSwipe)
            """
            
        }
        
    }
    
}
