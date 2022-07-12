//
//  AppFeedbackOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct AppFeedbackOpenCount: Analytic {
        
    var title: String = "App Feedback Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.globalFeedbackOpened], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
