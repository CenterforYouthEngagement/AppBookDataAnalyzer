//
//  VocabTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct VocabTapCount: Analytic {
    
    let eventCode = 27
    
    var title: String = "Vocab Popover Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND \(Database.EventLog.Column.code) = \(eventCode)
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
