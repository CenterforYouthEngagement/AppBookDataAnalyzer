//
//  DragDropEnlargeDraggableNoMetadata.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/28/22.
//

import Foundation

struct DragDropEnlargeDraggableNoMetadata: Analytic {
        
    var title: String = "Drag and Drop - Enlarge Draggable Count - No Metadata Available"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                return try Database.count(events: [.draggableOpenedNoMeta], appbookId: appbook.id, pageNumber: pageNumber, in: db)
                
            case .job(_):
                return nil
            }
            
            
        }
        
    }
    
}
