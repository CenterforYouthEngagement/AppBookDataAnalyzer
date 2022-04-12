//
//  MovieFullScreenEntered.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/31/22.
//

import Foundation

struct MovieFullScreenEntered: Analytic {
        
    var title: String = "Movie Player - Full Screen Entered"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.moviePlayerEnteredFullscreen], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
