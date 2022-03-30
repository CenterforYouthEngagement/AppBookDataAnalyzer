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
                    FROM \(Database.)
                    FROM checklist_selected_items
                    JOIN checklist_items
                    ON checklist_items.id = checklist_selected_items.checklist_item_id
                    JOIN question_to_page_join
                    ON question_to_page_join.question_id = checklist_items.question_id
                    WHERE question_to_page_join.question_id = 1613
                    AND question_to_page_join.appbook_id = 91
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
