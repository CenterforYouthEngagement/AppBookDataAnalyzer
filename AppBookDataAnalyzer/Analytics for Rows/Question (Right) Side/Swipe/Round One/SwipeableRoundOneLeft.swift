//
//  SwipeableRoundOneLeft.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//


import Foundation

struct SwipeableRoundOneLeft: Analytic {
    
    var title: String = "Swipe - Round One - Left"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = Database.SwipeableStudentAnswer.generateRoundOneQuery(isRightSwipe: false, appbookId: appbook.id, pageNumber: pageNumber)
                
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
