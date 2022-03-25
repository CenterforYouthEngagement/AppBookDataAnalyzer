//
//  JobSalaryEducationModalOpenCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

struct JobSalaryEducationModalOpenCount: Analytic {
        
    var title: String = "Job - Salary Education Modal Open Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        await Database.Job.analyze(eventCode: 42, database: database, textbookMaterial: textbookMaterial)
        
    }
    
}
