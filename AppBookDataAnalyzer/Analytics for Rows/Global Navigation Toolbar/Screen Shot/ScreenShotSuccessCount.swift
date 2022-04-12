//
//  ScreenShotSuccessCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct ScreenShotSuccessCount: Analytic {
        
    var title: String = "Screen Shot Success Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.screenCaptureSucceeds], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
