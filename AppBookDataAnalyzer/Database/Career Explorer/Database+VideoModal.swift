//
//  Database+VideoModal.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/25/22.
//

import Foundation

extension Database {
        
    struct VideoModal {
        static let tableName = "exploration_leaf_video_modal_content"
        struct Column {
            static let id = "id"
            static let fileName = "video_file_name"
        }
    }

    
}
