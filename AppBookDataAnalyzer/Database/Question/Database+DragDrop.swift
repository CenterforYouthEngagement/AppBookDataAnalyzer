//
//  Database+DragDrop.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

extension Database {
        
    struct DragDropStudentAnswer {
        static let tableName = "dd_student_answer"
        struct Column {
            static let id = "id"
            static let questionId = "question_id"
        }
    }
    
}
