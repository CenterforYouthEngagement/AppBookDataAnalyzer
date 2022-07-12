//
//  NavigationHistoryPageOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 4/6/22.
//

import Foundation

struct NavigationHistoryPageOpenCount: Analytic {
        
    var title: String = "Navigation History Page Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.navigationHistoryPageOpenedModally], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
