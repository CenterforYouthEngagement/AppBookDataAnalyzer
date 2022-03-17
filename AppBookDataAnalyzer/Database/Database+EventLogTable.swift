//
//  Database+EventLogTable.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/10/22.
//

import Foundation

extension Database {
    
    struct EventLog {
        static let tableName = "event_log"
        struct Column {
            static let id = "id"
            static let code = "code"
            static let description = "description"
            static let timestamp = "timestamp"
            static let contextId = "context_id"
            static let appbookId = "appbook_id"
            static let pageNumber = "page_number"
        }
    }
    
}
