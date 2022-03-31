//
//  MovieNumInteractions.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/31/22.
//

import Foundation

struct MovieNumInteractions: Analytic {
    
    let moviePlayerPlayedEventCode = 0
    let moviePlayerStoppedEventCode = 1
    let moviePlayerClosedCaptionOnEventCode = 10
    let moviePlayerClosedCaptionOffEventCode = 11
    let moviePlayerFullScreenOnEventCode = 12
    let moviePlayerFullScreenOffEventCode = 13
    let moviePlayerScreenshotStartedEventCode = 9
    let movieCaptureStartedEventCode = 4
    
    var title: String = "Movie Player - Full Screen Entered"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND (
                        \(Database.EventLog.Column.code) = \(moviePlayerPlayedEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerStoppedEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerClosedCaptionOnEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerClosedCaptionOffEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerFullScreenOnEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerFullScreenOffEventCode)
                        OR \(Database.EventLog.Column.code) = \(moviePlayerScreenshotStartedEventCode)
                        OR \(Database.EventLog.Column.code) = \(movieCaptureStartedEventCode)
                    )
                """
                
                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
                }
                
                return String(count)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
