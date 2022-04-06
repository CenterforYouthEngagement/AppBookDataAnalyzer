//
//  JobTypicalTasksModalOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobTypicalTasksModalOpenCount: Analytic {
        
    var title: String = "Job - Typical Tasks - Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(event: .typicalTaskModalOpened, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
