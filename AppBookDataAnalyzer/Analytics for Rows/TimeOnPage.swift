//
//  TimeOnPage.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/10/22.
//

import GRDB
import Foundation

struct TimeOnPage: Analytic {
    
    // TODO: Change these once the PR is merged in with these codes
    let pageOpenedEventCode: Int = -1
    let pageClosedEventCode: Int = -2
    let jobOpenedEventCode: Int = -3
    let jobClosedEventCode: Int = -4
    
    
    var title: String = "Time"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try! await database.pool.read { db in // TODO: Remove the ! from the try - just for debug
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let rows = try Row.fetchCursor(db, sql: """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE
                        \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND
                        \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND (
                            \(Database.EventLog.Column.code) = \(pageOpenedEventCode)
                        OR
                            \(Database.EventLog.Column.code) = \(pageClosedEventCode)
                        )
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """)
                
                // The total time that has been spent on this page
                var totalTime: TimeInterval = 0.0
                
                // A stack of currently open dates for pages
                // Nesting of page opens occurs if a student opens a page from navigation history modally
                // and it's the same page as the one that's open in main page naviagtion
                var currentOpenDates: [Date] = []
                
                // The parens interview question problem: algorithm that parses strings with nested parens
                // Using a stack (in this case `currentOpenDates`) enables nesting
                while let row = try rows.next() {
                    
                    let eventCode: Int = row[Database.EventLog.Column.code]
                    
                    let timestamp: Double = row[Database.EventLog.Column.timestamp]
                    let rowDate = Date(timeIntervalSince1970: timestamp)
                    
                    if eventCode == pageOpenedEventCode {
                        
                        currentOpenDates.append(rowDate)
                        
                        
                    } else if let latestOpenDate = currentOpenDates.last {
                        // if the `eventCode` isn't an open code, it's closed
                        // grab the last open date from the stack and add the difference to `totalTime`
                        
                        totalTime += latestOpenDate.distance(to: rowDate)
                        currentOpenDates = currentOpenDates.dropLast()
                        
                    }
                }
                
                return String(totalTime)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
