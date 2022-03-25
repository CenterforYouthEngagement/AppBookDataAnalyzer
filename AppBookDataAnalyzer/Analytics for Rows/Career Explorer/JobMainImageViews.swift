//
//  JobMainImageViews.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation

struct JobMainImageViews: Analytic {
        
    var title: String = "Job - Main Image View Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 40, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
