//
//  ScreenShotCancelCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct ScreenShotCancelCount: Analytic {
    
    let eventCode = 61
    
    var title: String = "Screen Shot Cancel Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(eventCodes: [eventCode], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
