//
//  PasswordSuccessCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct PasswordSuccessCount: Analytic {
    
    let eventCode = 72
    
    var title: String = "Password Success Count"
    
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
