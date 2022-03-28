//
//  GalleryPagingCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct GalleryPagingCount: Analytic {
    
    let pageLeftEventCode = 28
    let pageRightEventCode = 27
    
    var title: String = "Gallery Paging Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(eventCodes: [pageLeftEventCode, pageRightEventCode], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
