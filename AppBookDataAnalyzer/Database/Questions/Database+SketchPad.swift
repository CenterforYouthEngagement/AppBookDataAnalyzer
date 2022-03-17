//
//  Database+SketchPadStudentAnswer.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

extension Database {
    
    struct SketchPadStudentAnswer {
        static let tableName = "sketchpad_student_answer"
        struct Column {
            static let id = "id"
            static let strokeCollectionId = "stroke_collection_id"
            static let questionId = "quiz_id"
            static let timestamp = "attempt_time"
        }
    }
    
    struct StrokeCollection {
        static let tableName = "stroke_collections"
        struct Column {
            static let id = "id"
        }
    }
    
    struct StrokeCollectionStroke {
        static let tableName = "stroke_collection_strokes"
        struct Column {
            static let id = "id"
            static let parentId = "parent_stroke_collection_id"
            static let strokeType = "type"
        }
        
        enum StrokeType: Int {
            case draw = 0
            case image = 1
        }
        
        
        static func generateQuery(for strokeType: StrokeType, appbookId: AppBook.ID, pageNumber: Int) -> String {
            
            """
                SELECT COUNT(*)
                FROM \(Database.StrokeCollectionStroke.tableName)
                JOIN \(Database.StrokeCollection.tableName)
                ON \(Database.StrokeCollectionStroke.tableName).\(Database.StrokeCollectionStroke.Column.parentId)
                    = \(Database.StrokeCollection.tableName).\(Database.StrokeCollection.Column.id)
                JOIN \(Database.SketchPadStudentAnswer.tableName)
                ON \(Database.StrokeCollection.tableName).\(Database.StrokeCollection.Column.id)
                    = \(Database.SketchPadStudentAnswer.tableName).\(Database.SketchPadStudentAnswer.Column.strokeCollectionId)
                JOIN \(Database.QuestionPageJoin.tableName)
                ON \(Database.SketchPadStudentAnswer.tableName).\(Database.SketchPadStudentAnswer.Column.questionId)
                    = \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.questionId)
                WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                    = \(appbookId)
                AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                    = \(pageNumber)
                AND \(Database.StrokeCollectionStroke.tableName).\(Database.StrokeCollectionStroke.Column.strokeType)
                    = \(strokeType.rawValue)
            """
            
        }
        
    }
    
}
