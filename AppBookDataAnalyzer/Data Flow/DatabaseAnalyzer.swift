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
    let analysisSession: AnalysisSession
    let outputFileName: String
    
    init(curriculum: Curriculum, database: Database, outputFileName: String) {
        self.curriculum = curriculum
        self.database = database
        self.analysisSession = AnalysisSession(curriculum: curriculum)
        self.outputFileName = outputFileName
    }
    
    func runDatabaseAnalysis() async -> URL? {
        
        await withTaskGroup(of: AnalysisSession.Entry.self) { taskGroup in
            
            for analytic in curriculum.analytics {
                
                for textbookMaterial in curriculum.textbookMaterials {
                    
                    taskGroup.addTask {
                        let analysisResult = await analytic.analyze(database: database,
                                                                    textbookMaterial: textbookMaterial)
                        return AnalysisSession.Entry(analysisResult: analysisResult,
                                                     textbookMaterial: textbookMaterial,
                                                     analytic: analytic)
                    }
                }
            }
            
            for await entry in taskGroup {
                await analysisSession.write(entry: entry)
            }
            
            // write the output to a CSV
            guard let outputURL = await analysisSession.exportCSV(named: outputFileName) else {
                print("Unable to write CSV to the disk")
                return nil
            }
            
            return outputURL
            
        }
        
    }
    
}
