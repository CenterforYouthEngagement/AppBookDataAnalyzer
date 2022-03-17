//
//  SketchPadDrawStrokeCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import GRDB
import Foundation

struct SketchPadDrawStrokeCount: Analytic {
        
    var title: String = "Sketch Pad - Stroke Count - Draw"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = Database.StrokeCollectionStroke.generateCountQuery(forStrokeType: .draw, appbookId: appbook.id, pageNumber: pageNumber)
                
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
