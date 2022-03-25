//
//  JobDetailsModalOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobDetailsModalOpenCount: Analytic {
    
    var title: String = "Job - Details - Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 45, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
