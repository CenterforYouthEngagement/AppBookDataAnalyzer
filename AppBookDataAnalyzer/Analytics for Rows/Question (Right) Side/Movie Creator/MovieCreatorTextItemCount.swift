//
//  MovieCreatorTextItemCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/18/22.
//

import Foundation

struct MovieCreatorTextItemCount: Analytic {
    
    var title: String = "Movie Creator - Text Items Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try! await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let count = try Database.MovieCreatorModification.count(ofContentType: .text,
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
