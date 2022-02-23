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
    
    /// Defines the current curriculum to be processed as INSITE
    static let current = insite20220418
    
    /// A representation of the INSITE curriculum used in the 2022-04-18 research study
    static let insite20220418 = Curriculum(appbooks: [], jobs: [])
    
}
