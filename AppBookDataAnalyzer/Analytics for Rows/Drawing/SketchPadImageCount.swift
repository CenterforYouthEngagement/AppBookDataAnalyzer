//
//  SketchPadImageCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//


import Foundation

struct SketchPadImageCount: Analytic {
        
    var title: String = "Sketch Pad - Stroke Count - Image"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = Database.StrokeCollectionStroke.generateCountQuery(forStrokeType: .image, appbookId: appbook.id, pageNumber: pageNumber)
                
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
