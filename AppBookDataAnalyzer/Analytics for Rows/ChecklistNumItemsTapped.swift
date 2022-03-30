//
//  ChecklistNumItemsTapped.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/30/22.
//

import Foundation

struct ChecklistNumOfItemsTapped: Analytic {
    
    let tableOfContentsEventCode = 00
    
    var title: String = "Checklist Number of Items Tapped"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                /*
                 
                 SELECT COUNT(*)
                 FROM CHECKLIST SELECTED ITEMS TABLE
                 JOIN EVENT LOG
                 ON EVENT LOG CONTEXT ID == OPEN RESPONSE COLUMN.ID
                 WHERE EVENTLOG.PAGENUMBER == PAGENUMBER
                 AND EVENTLOG.APPBOOKID = APPBOOKID
                 AND
                 
                 
                 
                 */
                
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
