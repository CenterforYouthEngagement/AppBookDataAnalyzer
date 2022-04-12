//
//  OpenResponseContainsEmoji.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

struct OpenResponseContainsEmoji: Analytic {
        
    var title: String = "Open Response - Contains Emoji"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let maybeCountString = try Database.count(events: [.emojiInStudentResponse], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
                guard let countString = maybeCountString, let count = Int(countString) else {
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
