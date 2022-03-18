//
//  PathBuilderNotebookItemsCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation
import GRDB

struct PathBuilderNotebookItemsCount: Analytic {
        
    var title: String = "Path Builder - Notebook Items Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                // get the event descriptions for modifications, as these have the nodes created as JSON in the description
                let eventLogQuery = """
                    SELECT \(Database.EventLog.Column.description)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(Database.PathBuilderModification.eventCode)
                """
                
                let rows = try Row.fetchCursor(db, sql: eventLogQuery)
                
                // keep a list of all the content ids from the decoded path builder nodes
                var createdContentIds = [Int]()
                
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
                    case .add(node: let node):
                        createdContentIds.append(node.contentId)
                    case .unknown:
                        continue
                    }
                    
                }
                
                guard createdContentIds.isEmpty == false else {
                    return nil
                }
                
                let contentIdsString = createdContentIds.map(String.init).joined(separator: ",")
                
                // check how many nodes have content that is not text
                let studentProjectContentQuery = """
                    SELECT COUNT(*)
                    FROM \(Database.StudentProjectContent.tableName)
                    WHERE \(Database.StudentProjectContent.Column.id) IN (\(contentIdsString))
                    AND \(Database.StudentProjectContent.Column.contentType) != '\(Database.StudentProjectContent.ContentType.text.rawValue)'
                """
                
                guard let count = try Int.fetchOne(db, sql: studentProjectContentQuery) else {
                    return nil
                }
                
                return String(count)
                                
            case .job(_):
                return nil
            }
            
            
        }
                
    }
    
    
}
