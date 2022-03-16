//
//  Database+Question.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/16/22.
//

import Foundation

extension Database {
    
    struct Question {
        
        typealias Id = Int
        
        static let tableName = "question"
        
        struct Column {
            static let id = "id"
            static let questionText = "question_text"
            static let imageId = "image_id"
            static let latestVersion = "latest_version"
            static let isCorrectable = "is_correctable"
            static let questionType = "question_type"
        }
    }
    
}
