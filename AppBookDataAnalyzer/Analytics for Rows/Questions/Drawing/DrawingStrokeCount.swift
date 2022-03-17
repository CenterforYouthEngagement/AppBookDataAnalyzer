//
//  DrawingStrokeCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import GRDB
import Foundation

struct DrawingStrokeCount: Analytic {
        
    var title: String = "Drawing - Stroke Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM stroke_collection_strokes
                    JOIN stroke_collections
                    ON stroke_collection_strokes.parent_stroke_collection_id
                        = stroke_collections.id
                    JOIN sketchpad_student_answer
                    ON stroke_collections.id
                        = sketchpad_student_answer.stroke_collection_id
                    JOIN question_to_page_join
                    ON sketchpad_student_answer.quiz_id
                        = question_to_page_join.question_id
                    WHERE question_to_page_join.appbook_id
                        = \(appbook.id)
                    AND question_to_page_join.page_number
                        = \(pageNumber)
                """
                
                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
                }
                
                return String(count)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
