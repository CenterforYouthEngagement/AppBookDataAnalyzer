//
//  MovieCreatorNarrationChangeCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation

struct MovieCreatorNarrationChangeCount: Analytic {
    
    var title: String = "Movie Creator - Narration Change Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let count = try Database.MovieCreatorModification.count(ofModificationType: .narration,
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
