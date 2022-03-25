//
//  JobTypicalTasksModalFlipCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobTypicalTasksModalFlipCount: Analytic {
    
    var title: String = "Job - Typical Tasks Modal Card Flip Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 44, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
