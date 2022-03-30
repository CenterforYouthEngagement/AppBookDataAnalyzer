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
                
                let query = """
                    SELECT COUNT(*)
                    FROM \(Database.ChecklistSelectedItems.tableName)
                    JOIN \(Database.ChecklistItems.tableName)
                    ON \(Database.ChecklistItems.Column.id) = \(Database.ChecklistSelectedItems.Column.checklistItemId)
                    JOIN \(Database.QuestionPageJoin.tableName)
                    ON \(Database.QuestionPageJoin.Column.id) = \(Database.QuestionPageJoin.Column.questionId)
                    WHERE \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.pageNumber)
                        = \(pageNumber)
                    AND \(Database.QuestionPageJoin.tableName).\(Database.QuestionPageJoin.Column.appbookId)
                        = \(appbook.id)
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
