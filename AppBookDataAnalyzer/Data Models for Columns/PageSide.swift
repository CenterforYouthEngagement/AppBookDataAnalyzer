//
//  PageSide.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/28/22.
//

import Foundation

enum PageSide: String, Hashable {
    
    case right, left
    
    var title: String {
        rawValue.capitalized
    }
    
}
