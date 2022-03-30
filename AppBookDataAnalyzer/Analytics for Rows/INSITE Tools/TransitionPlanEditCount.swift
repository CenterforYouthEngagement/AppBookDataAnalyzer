//
//  TransitonPlanEditCount.swift
//  AppBookDataAnalyzer
//
//  Created by Francis Furnelli on 3/29/22.
//

import Foundation
struct TransitionPlanEditCount: Analytic {
    
    let eventCode = 56//change
    
    var title: String = "Transition Plan Edit Count"
    
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
