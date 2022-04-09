//
//  Database+BaseEventCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation
import GRDB
import AppBookAnalyticEvents

extension Database {
    
    /// Basic `SELECT COUNT(*)` that counts the `event_log` for rows where `eventCodes` occured in the given `appbookId` on the `pageNumber`. Single  `eventCodes` arrays are support. When `eventCodes.count > 1`, an `OR` statement will be used when checking for each of the `eventCodes` in `event_log`
    /// - Parameters:
    ///   - events: An array of `AppBookAnalyticEvent` events. Reference can be found [here](https://github.com/CenterforYouthEngagement/AppBookAnalyticEvents/blob/main/Sources/AppBookAnalyticEvents/AppBookAnalyticEvent.swift)
    ///   - appbookId: The `AppBook.ID`, most likely present in the `TextbookMaterial` passed in during the `anaylze` function for an `Analytic`
    ///   - pageNumber: The `pageNumber` in the `AppBook`, most likely present in the `TextbookMaterial` passed in during the `anaylze` function for an `Analytic`
    ///   - database: A reference to the `GRDB.Database` to run the query on. See `TableOfContentsOpened.swift:19` for how to get a reference to the database.
    static func count(events: [AppBookAnalyticEvent],
                      appbookId: AppBook.ID,
                      pageNumber: Int,
                      in database: GRDB.Database)
    throws -> String? {
        
        let eventCodeConditional = events
            .map(\.code)
            .map(String.init)
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
