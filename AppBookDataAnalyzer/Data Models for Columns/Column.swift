//
//  Column.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

enum Column {
    
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
