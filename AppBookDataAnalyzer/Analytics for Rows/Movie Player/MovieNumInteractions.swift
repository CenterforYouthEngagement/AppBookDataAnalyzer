//
//  MovieNumInteractions.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/31/22.
//

import Foundation

struct MovieNumInteractions: Analytic {
    
    var title: String = "Movie Player - Total Number of Interactions With Controls"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.moviePlayerPlayed,
                                                   .moviePlayerStopped,
                                                   .moviePlayerCloseCaptionTurnedOn,
                                                   .moviePlayerCloseCaptionTurnedOff,
                                                   .moviePlayerEnteredFullscreen,
                                                   .moviePlayerScreenShotStarted,
                                                   .moviePlayerCaptureStarted,
                                                    ],
                                          appbookId: appbook.id,
                                          pageNumber: pageNumber,
                                          in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
