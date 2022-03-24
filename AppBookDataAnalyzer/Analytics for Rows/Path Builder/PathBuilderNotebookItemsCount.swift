//
//  PathBuilderNotebookItemsCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

struct PathBuilderNotebookItemsCount: Analytic {
    
    var title: String = "Path Builder - Notebook Items Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let count = try Database.PathBuilderModification.count(ofTextItems: false,
                                                                       appbookId: appbook.id,
                                                                       pageNumber: pageNumber,
                                                                       in: db)
                
                return String(count)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
