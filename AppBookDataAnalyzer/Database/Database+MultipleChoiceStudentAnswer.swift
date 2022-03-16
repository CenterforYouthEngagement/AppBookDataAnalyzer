//
//  Database+MultipleChoiceStudentAnswer.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//

import Foundation

extension Database {
    
    struct MultipleChoiceStudentAnswer {
        static let tableName = "mc_student_answer"
        struct Column {
            static let id = "id"
            static let questionId = "quiz_id"
            static let possibleAnswerId = "possible_answer_id"
            static let time = "attempt_time"
            
            /// Int, enables grouping of rows from this table to determine the state of the quiz after each selection.
            /// After each selection, `n` rows are added to this table with the same version number
            /// (`n` being the number of possible answers for this quiz)
            static let version = "version"
            
            /// Binary, describes if the quiz has been submitted or not.
            /// If 1, the quiz was submitted like this
            /// If 0, the user just changed an answer and didn't hit submit
            static let isSubmitted = "is_submitted"
            static let isSelected = "is_selected"
        }
    }
    
}
