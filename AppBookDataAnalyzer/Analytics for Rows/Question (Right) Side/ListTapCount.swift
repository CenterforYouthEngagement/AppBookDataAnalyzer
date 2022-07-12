//
//  ListTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 4/15/22.
//

import Foundation

struct ListTapCount: Analytic {
    
    var title: String = "List - Number of Items Tapped"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.listItemTapped], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
