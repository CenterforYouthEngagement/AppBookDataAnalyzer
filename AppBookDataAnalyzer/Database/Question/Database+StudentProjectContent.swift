//
//  Database+StudentProjectContent.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

extension Database {
        
    struct StudentProjectContent {
        
        static let tableName = "student_project_content"
        
        struct Column {
            static let id = "id"
            static let contentType = "content_type"
        }
        
        enum ContentType: String, CaseIterable {
            case text, sketch, pathBuilder, other
            
        }
        
    }

    
}
