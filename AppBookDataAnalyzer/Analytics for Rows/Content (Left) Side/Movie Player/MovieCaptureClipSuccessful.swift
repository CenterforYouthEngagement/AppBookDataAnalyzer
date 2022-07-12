//
//  MovieCaptureClipSuccessful.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/31/22.
//

import Foundation

struct MovieCaptureClipSuccessful: Analytic {
        
    var title: String = "Movie Player - Capture Clip Successful"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.moviePlayerCaptureSucceeded], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
