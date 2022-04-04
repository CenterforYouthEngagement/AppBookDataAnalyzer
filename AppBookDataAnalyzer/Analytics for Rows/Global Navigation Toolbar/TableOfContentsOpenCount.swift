//
//  TableOfContentsOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/10/22.
//

import Foundation

struct TableOfContentsOpenCount: Analytic {
    
    let tableOfContentsEventCode = 54
    
    var title: String = "Table of Contents Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(eventCodes: [tableOfContentsEventCode], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
