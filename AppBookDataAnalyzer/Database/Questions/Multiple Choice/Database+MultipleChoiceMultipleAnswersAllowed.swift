//
//  Database+MultipleChoiceMultipleAnswersAllowed.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//

import Foundation

extension Database {
    
    struct MultipleChoiceMultipleAnswersAllowed {
        static let tableName = "mc_multiple_answers_allowed"
        struct Column {
            static let id = "id"
            static let questionId = "quiz_id"
            static let maxSelectedAnswersAllowed = "max_selected_answers_allowed"
        }
    }
    
}
