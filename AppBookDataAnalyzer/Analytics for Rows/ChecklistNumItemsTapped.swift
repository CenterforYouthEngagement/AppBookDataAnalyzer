//
//  ChecklistNumItemsTapped.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/30/22.
//

import Foundation

struct ChecklistNumOfItemsTapped: Analytic {
    
    let tableOfContentsEventCode = 00
    
    var title: String = "Checklist Number of Items Tapped"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM 
                """
                
                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
                }
                
                return String(count)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
