//
//  OpenResponseContainsEmoji.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

struct OpenResponseContainsEmoji: Analytic {
    
    let containsEmojiEventCode = -1 // TODO - update when #2222 is merged
    
    var title: String = "Open Response - Contains Emoji"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(containsEmojiEventCode)
                """
                
                guard let count = try Int.fetchOne(db, sql: query) else {
                    return nil
                }
                
                if count > 0 {
                    return "True"
                } else {
                    return "False"
                }
                
            case .job(_):
                return nil
                
            }
            
        }
        
    }
    
}
