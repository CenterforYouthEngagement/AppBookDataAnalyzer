//
//  DataPipelineManager.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

/// Manager class that handles connecting the objects managing:
/// - the dropping of documents directories on the app
/// - parsing the student data from the dropped directory
/// - running the analytics on the student data
struct DataPipelineManager {
    
    let dropDelegate = DirectoryDropDelegate()
    
    let curriculum: Curriculum
    
    init(curriculum: Curriculum) {
        self.curriculum = curriculum
        dropDelegate.urlHandler = documentsDirectoryFound(url:)
    }
    
    func documentsDirectoryFound(url: URL) {
        let dataDirectory = DataDirectory(documentsDirectory: url)
        dataDirectory.databases.forEach(analyze(database:))
    }
    
    func analyze(database: Database) {
        let analyzer = DatabaseAnalyzer(curriculum: curriculum, database: database)
        analyzer.runDatabaseAnalysis()
    }
    
}
