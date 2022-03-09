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
    
    let analytics: [Analytic]
    
    let textbookMaterials: [TextbookMaterial]
        
    init(appbooks: [AppBook], jobs: [Job], analytics: [Analytic]) {
        self.appbooks = appbooks
        self.jobs = jobs
        self.analytics = analytics
        
        let appBookColumns: [TextbookMaterial] = appbooks.map { appbook in
            (0 ..< appbook.pageCount).map { pageNumber in
                [
                    TextbookMaterial.page(appbook: appbook, pageNumber: pageNumber, side: .left),
                    TextbookMaterial.page(appbook: appbook, pageNumber: pageNumber, side: .right),
                ]
            }.flatMap { $0 } // flattens the array of [[[Column]]] to [[Column]]
        }.flatMap { $0 } // flattens the array of [[Column]] to [Column]
        
        let jobsColumbs = jobs.map(TextbookMaterial.job)
        
        self.textbookMaterials = appBookColumns + jobsColumbs
        
    }
    
}
