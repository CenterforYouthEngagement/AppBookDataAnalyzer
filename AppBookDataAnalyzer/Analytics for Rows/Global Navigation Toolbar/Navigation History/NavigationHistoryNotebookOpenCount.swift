//
//  NavigationHistoryNotebookOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 4/6/22.
//

import Foundation

struct NavigationHistoryNotebookOpenCount: Analytic {
        
    var title: String = "Navigation History Open Count - Notebook"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.navigationHistoryOpenedFromNotebook], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
