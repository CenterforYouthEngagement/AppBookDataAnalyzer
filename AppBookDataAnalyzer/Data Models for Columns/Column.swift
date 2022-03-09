//
//  Column.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

enum TextbookMaterial {
    
    case page(appbook: AppBook, pageNumber: Int, side: PageSide)
    case job(_: Job)
    
    var title: String {
        switch self {
        case .page(appbook: let appbook, pageNumber: let pageNumber, side: let side):
            return "\(appbook.title).\(pageNumber).\(side.title)"
        case .job(let job):
            return job.title
        }
    }
    
}

extension TextbookMaterial: Hashable {
    
    static func == (lhs: TextbookMaterial, rhs: TextbookMaterial) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        
        switch self {
            
        case .page(appbook: let appbook, pageNumber: let pageNumber, side: let side):
            hasher.combine(appbook)
            hasher.combine(pageNumber)
            hasher.combine(side)

        case .job(let job):
            hasher.combine(job)

        }
    }
    
    
}
