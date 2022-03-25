//
//  PathBuilderLinksCreated.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation
import GRDB

struct PathBuilderLinksCreated: Analytic {
        
    var title: String = "Path Builder - Links Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                // get the event descriptions for modifications, as these have the links created as JSON in the description
                let eventLogQuery = """
                    SELECT \(Database.EventLog.Column.description)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(Database.PathBuilderModification.eventCode)
                """
                
                let rows = try Row.fetchCursor(db, sql: eventLogQuery)
                
                // keep a list of all the content ids from the decoded path builder nodes
                var linkCount = 0
                
                while let row = try rows.next() {
                    
                    // attempt to convert the nodes to codable `PathBuilderModification` objects
                    let description: String = row[Database.EventLog.Column.description]
                    guard
                        let rawJSON = description.components(separatedBy: Database.PathBuilderModification.eventDescriptionPrefixText).last,
                        let data = rawJSON.data(using: .utf8)
                    else {
                        continue
                    }
                    let modification = try JSONDecoder().decode(Database.PathBuilderModification.self, from: data)
                    
                    switch modification {
                    case .created(link: _):
                        linkCount += 1
                    default:
                        continue
                    }
                    
                }
                     
                return String(linkCount)
                
            case .job(_):
                return nil
            }
            
            
        }
                
    }
    
}
