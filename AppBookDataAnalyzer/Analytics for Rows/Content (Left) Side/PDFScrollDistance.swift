//
//  PDFScrollDistance.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation
import GRDB
import AppBookAnalyticEvents

struct PDFScrollDistance: Analytic {
        
    private let eventDescriptionFileNamePercentageSplitter = ".pdf - "
    
    var title: String = "PDF Scroll Distance"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(AppBookAnalyticEvent.pdfScrollPercentageChanged.code)
                    ORDER BY \(Database.EventLog.Column.description) DESC
                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                // cumalative of the percentages in the event_log
                var totalPercentage = 0.0
                
                var seenPDFs = Set<String>()
                
                while let row = try rows.next() {
                    
                    let description: String = row[Database.EventLog.Column.description]
                    
                    // the components will be the (event's name + pdf's file name) and percentage
                    let components = description.components(separatedBy: eventDescriptionFileNamePercentageSplitter)
                    guard let prefixAndFileName = components.first,
                          let percentageString = components.last,
                          let percentage = Double(percentageString)
                    else {
                        continue
                    }
                    
                    // If we've already seen this PDF don't add the percentage.
                    // The highest percentage will always be the first time since we're sorting the query results
                    if seenPDFs.contains(prefixAndFileName) {
                        continue
                    }
                    
                    totalPercentage += percentage
                    seenPDFs.insert(prefixAndFileName)
                    
                }
                
                return String(totalPercentage)
                
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
    
}
