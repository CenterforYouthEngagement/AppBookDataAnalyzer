//
//  DatabaseAnalyzer.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

/// The model that runs analysis for analytic over the database using the curriculumns columns
struct DatabaseAnalyzer {
    
    let curriculum: Curriculum
    let database: Database
    let output: CSVOutput
    
    func runDatabaseAnalysis() {
        
        // set up the CSV output with the column headers for this curriculum
        output.prepareColumnHeaders(for: curriculum)
        
        for analytic in curriculum.analytics {
            
            // start a new row for this analytic
            output.startNewRow(named: analytic.title)
            
            // for each column in the curriculum, analyze this column using the current analytic
            for column in curriculum.columns {
                
                let analysis = analytic.analyze(database: database, column: column)
                output.add(entry: analysis)
                
            }
            
        }
        
        // write the output to a CSV
        guard let outputURL = output.writeCSVToDisk() else {
            print("Unable to write CSV to the disk")
            return
        }
        
        print(outputURL.path) // TODO - let do something on the UI
        
    }
    
}
