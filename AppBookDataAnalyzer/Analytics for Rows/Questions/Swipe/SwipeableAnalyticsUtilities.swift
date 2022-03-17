//
//  SwipeableAnalyticsUtilities.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

struct SwipeableAnalytics {
    
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
