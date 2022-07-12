//
//  MovieCreatorNotebookItemCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation

struct MovieCreatorNotebookItemCount: Analytic {
    
    var title: String = "Movie Creator - Other Notebook Item Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let count = try Database.MovieCreatorModification.count(ofContentType: .other,
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
