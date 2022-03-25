//
//  MoviePlayTime.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation
import GRDB
import Regex

struct MoviePlayTime: Analytic {
    
    let moviePlayerPlayEventCode = 0
    let moviePlayerStoppedEventCode = 1
    
    var title: String = "Movie Player - Play Time"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND (
                        \(Database.EventLog.Column.code) = \(moviePlayerPlayEventCode)
                        OR
                        \(Database.EventLog.Column.code) = \(moviePlayerStoppedEventCode)
                    )
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """
                
                
                var totalTime = 0.0
                var mostRecentStartTime: Double? = nil
                
                let regex = Regex(#"@-[0-9]*\.[0-9]*"#) // movie event descriptions include the time syntax @-#.###
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                while let row = try rows.next() {
                    
                    let code: Int = row[Database.EventLog.Column.code]
                    let description: String = row[Database.EventLog.Column.description]
                    
                    guard let playheadRegexMatch: String = regex.firstMatch(in: description)?.value,
                          let timeString = playheadRegexMatch.components(separatedBy: "@-").last,
                          let playhead = Double(timeString) else {
                        continue
                    }
                    
                    if let startTime = mostRecentStartTime {
                        
                        totalTime += playhead - startTime
                        mostRecentStartTime = nil
                        
                    } else if code == moviePlayerPlayEventCode {
                        // if we don't have a mostRecentStartTime, save the playhead as mostRecentStartTime if it's for a play event code
                        
                        mostRecentStartTime = playhead
                        
                    } // if theres no mostRecentStartTime and we're not looking at a play event code, forget a stopped playing event code
                    
                }
                
                
                return totalTime.formatted(.number.precision(.significantDigits(2)))
                
                
            case .job(let job):
                
//                let query = """
//                    SELECT COUNT(*)
//                    FROM \(Database.EventLog.tableName)
//                    WHERE \(Database.EventLog.Column.code) = \(jobMainImageEventCode)
//                    AND \(Database.EventLog.Column.contextId) = \(job.id)
//                """
//
//                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
//                }
//
//                return String(count)
                
            }
            
        }
        
    }
    
}
