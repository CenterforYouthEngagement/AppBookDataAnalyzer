//
//  Database+QuestionPageJoin.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//

import Foundation

extension Database {
    
    struct QuestionPageJoin {
        static let tableName = "question_to_page_join"
        struct Column {
            static let id = "id"
            static let questionId = "question_id"
            static let appbookId = "appbook_id"
            static let pageNumber = "page_number"
        }
    }
    
}
