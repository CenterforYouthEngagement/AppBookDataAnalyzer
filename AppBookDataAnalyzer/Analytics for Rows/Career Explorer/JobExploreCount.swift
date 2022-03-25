//
//  JobExploreCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation

struct JobExploreCount: Analytic {
        
    var title: String = "Job - Explored Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 39, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
