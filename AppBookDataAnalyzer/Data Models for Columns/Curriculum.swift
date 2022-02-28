//
//  Curriculum.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

/// Object defining the structure of the book's content
struct Curriculum {
    
    /// An array of the AppBooks in the curriculum. The order set for these AppBooks describes the order they'll be in the output
    let appbooks: [AppBook]
    
    /// The jobs displayed to the user in this curriculum
    let jobs: [Job]
    
    var columns: [Column] {
        
        var columns: [Column] = appbooks.map { appbook in
            (0 ..< appbook.pageCount).map { pageNumber in
                [
                    Column.page(appbook: appbook, pageNumber: pageNumber, side: .left),
                    Column.page(appbook: appbook, pageNumber: pageNumber, side: .right),
                ]
            }.flatMap { $0 } // flattens the array of [[[Column]]] to [[Column]]
        }.flatMap { $0 } // flattens the array of [[Column]] to [Column]
        
        let jobs = jobs.map(Column.job)
        columns.append(contentsOf: jobs)
        
        return columns
        
    }
    
}
