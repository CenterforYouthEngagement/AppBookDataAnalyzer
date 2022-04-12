//
//  JobRelatedJobsModalOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobRelatedJobsModalOpenCount: Analytic {
    
    var title: String = "Job - Related Jobs - Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(event: .relatedJobsModalOpened, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
