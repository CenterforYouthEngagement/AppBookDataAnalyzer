//
//  JobDetailsModalWorkplaceValueTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobDetailsModalWorkplaceValueTapCount: Analytic {
    
    var title: String = "Job - Details - Workplace Value Tap Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(event: .jobDetailsModalWorkplaceValueTapped, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
