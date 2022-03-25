//
//  JobRelatedJobsModalJobTapCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobRelatedJobsModalJobTapCount: Analytic {
    
    var title: String = "Job - Related Jobs - Job Tap Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 49, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
