//
//  JobDetailsModalWorkplaceValueJobTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobDetailsModalWorkplaceValueJobTapCount: Analytic {
    
    var title: String = "Job - Details - Workplace Value to Job Tap Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 47, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
