//
//  DataPipelineManager.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import AppKit

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
        analyze(dataDirectory: dataDirectory)
    }
    
    func analyze(dataDirectory: DataDirectory) {
        
        Task {
            
            await withTaskGroup(of: URL?.self) { taskGroup in
                
                for database in dataDirectory.databases {
                    
                    taskGroup.addTask {
                        await DatabaseAnalyzer(curriculum: curriculum,
                                               database: database,
                                               outputFileName: "\(dataDirectory.title) - \(database.title)")
                                .runDatabaseAnalysis()
                    }
                    
                    for await url in taskGroup {
                        print(String(describing: url))
                    }
                    
                    cleanUpAnalysis()
                    showOutputDirectory()
                    
                }
                
            }
            
        }
        
    }
    
    func showOutputDirectory() {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
    }
    
    func cleanUpAnalysis() {
        
        guard
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let analysisFiles = try? FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                             includingPropertiesForKeys: nil,
                                                                             options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
        else {
            print("Couldn't find documents directory")
            return
        }
        
        let fileExtensionsToCleanup = [
            "sql",
            "sql-wal",
            "sql-shm",
        ]
        
        for file in analysisFiles {
            for fileExtension in fileExtensionsToCleanup {
                if file.lastPathComponent.contains(fileExtension) {
                    try? FileManager.default.removeItem(at: file)
                    break
                }
            }
        }
    
    }
    
}
