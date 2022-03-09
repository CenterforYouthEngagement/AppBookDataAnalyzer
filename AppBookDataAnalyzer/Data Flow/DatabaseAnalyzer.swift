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
    
    init(curriculum: Curriculum, database: Database, outputFileName: String) {
        self.curriculum = curriculum
        self.database = database
        self.output = CSVOutput(curriculum: curriculum, outputTitle: outputFileName)
    }
    
    func runDatabaseAnalysis() {
        
        for analytic in curriculum.analytics {
            
            // for each column in the curriculum, analyze this column using the current analytic
            for content in curriculum.textbookMaterials {
                
                let analysis = analytic.analyze(database: database, textbookMaterial: content)
                output.write(entry: analysis, textbookMaterial: content, analytic: analytic)
                
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
