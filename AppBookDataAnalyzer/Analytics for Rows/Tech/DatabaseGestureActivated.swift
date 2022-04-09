//
//  DatabaseGestureActivated.swift
//  AppBookDataAnalyzer
//
//  Created by Francis Furnelli on 3/25/22.
//

import Foundation
struct DatabaseGestureActivated: Analytic {
    
    var title: String = "Database Gesture Activated"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.databaseUploadGestureActivated], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
