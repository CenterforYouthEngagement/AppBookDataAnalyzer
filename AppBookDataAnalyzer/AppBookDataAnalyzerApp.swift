//
//  AppBookDataAnalyzerApp.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import SwiftUI

@main
struct AppBookDataAnalyzerApp: App {
    
    static var currentCurriculum = Curriculum.insite20220418
    
    let pipelineManager = DataPipelineManager(curriculum: currentCurriculum)
    
    var body: some Scene {
        WindowGroup {
            DirectoryDropView(dropDelegate: pipelineManager.dropDelegate)
        }
    }
}
