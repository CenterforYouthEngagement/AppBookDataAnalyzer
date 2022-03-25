//
//  Database+Job.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

extension Database {
    
    struct Job {
        static let tableName = "job"
        struct Column {
            static let id = "id"
            static let videoModalId = "video_modal_id"
        }
    }

}
