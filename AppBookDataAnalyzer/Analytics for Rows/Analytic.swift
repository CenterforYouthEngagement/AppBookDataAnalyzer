//
//  Analytic.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/28/22.
//

import Foundation

protocol Analytic {
    
    /// The name of the analytic, to be used as the row title
    var title: String { get }
    
    /// Run the analysis needed for this analytic using the given `database`.
    /// Output should be a String so that it can be placed in a CSV
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String?
    
}
