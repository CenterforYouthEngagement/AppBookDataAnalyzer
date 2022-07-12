//
//  FormResponseCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 4/15/22.
//

import Foundation

struct FormResponseCount: Analytic {
    
    var title: String = "Form - Number of Options Filled In"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.formResponseFilled], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
