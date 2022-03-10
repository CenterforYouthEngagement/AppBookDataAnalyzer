//
//  TableOfContentsOpened.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/10/22.
//

import GRDB
import Foundation

struct TableOfContentsOpened: Analytic {
    
    let tableOfContentsEventCode = 20
    
    var title: String = "Table of Contents Opened"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try! await database.pool.read { db in // TODO: Remove the ! from the try - just for debug
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(tableOfContentsEventCode)
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
