//
//  Database+BaseEventCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation
import GRDB

extension Database {
    
    static func count(eventCodes: [Int],
                      appbookId: AppBook.ID,
                      pageNumber: Int,
                      in database: GRDB.Database)
    throws -> String? {
        
        let eventCodeConditional = eventCodes.map(String.init)
            .joined(separator: " OR \(Database.EventLog.Column.code) = ")
        
        let query = """
            SELECT COUNT(*)
            FROM \(Database.EventLog.tableName)
            WHERE \(Database.EventLog.Column.appbookId) = \(appbookId)
            AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
            AND (
                \(Database.EventLog.Column.code) = \(eventCodeConditional)
            )
        """
        
        guard let count = try Int.fetchOne(database, sql: query) else {
            return nil
        }
        
        return String(count)
        
        
        
    }
    
}
