//
//  Database+OpenResponse.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

extension Database {
        
    struct OpenResponseStudentAnswer {
        static let tableName = "or_student_answer"
        struct Column {
            static let id = "id"
            static let questionId = "quiz_id"
            static let answer = "answer"
            static let time = "attempt_time"
            
            /// Int, enables versioning of the answers. A new version is created after each submit
            static let version = "version"
            static let replacingQuestionId = "replacing_question_id"
        }
    }

    
}
