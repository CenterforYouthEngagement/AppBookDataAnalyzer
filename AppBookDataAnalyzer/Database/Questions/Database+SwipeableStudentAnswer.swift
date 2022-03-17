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
    }
    
}
