//
//  GalleryPagingCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct GalleryPagingCount: Analytic {
    
    let pageLeftEventCode = 28
    let pageRightEventCode = 29
    
    var title: String = "Gallery Paging Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND (
                        \(Database.EventLog.Column.code) = \(pageLeftEventCode)
                        OR
                        \(Database.EventLog.Column.code) = \(pageLeftEventCode)
                    )
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
