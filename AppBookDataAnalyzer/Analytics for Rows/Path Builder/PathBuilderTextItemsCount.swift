//
//  PathBuilderTextItemsCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

struct PathBuilderTextItemsCount: Analytic {
        
    var title: String = "Path Builder - Text Items Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let count = try Database.PathBuilderModification.count(ofTextItems: true,
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
