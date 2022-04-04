//
//  Database+Slider.swift
//  AppBookDataAnalyzer
//
//  Created by Francis Furnelli on 3/30/22.
//

import Foundation
extension Database {
    struct SliderStudentAnswer {
        static let tableName = "slider_student_answers"
        struct Column {
            static let id = "id"
            static let questionId = "question_id"
            static let response = "response"
            static let time = "attempt_time"
        }
    }
}
