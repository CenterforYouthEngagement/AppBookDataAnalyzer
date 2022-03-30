//
//  Database+ChecklistStudentAnswer.swift
//  AppBookDataAnalyzer
//
//  Created by Sam DuBois on 3/30/22.
//

import Foundation

struct ChecklistItems {
    static let tableName = "checklist_items"
    struct Column {
        static let id = "id"
        static let questionId = "question_id"
        static let description = "description"
        static let imageId = "image_id"
        static let rank = "rank"
    }
}

struct ChecklistSelectedItems {
    static let tableName = "checklist_selected_items"
    struct Column {
        static let id = "id"
        static let checklistItemId = "checklist_item_id"
        static let isSelected = "is_selected"
        static let timestamp = "timestamp"
    }
}
