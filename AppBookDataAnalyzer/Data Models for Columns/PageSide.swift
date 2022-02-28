//
//  PageSide.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/28/22.
//

import Foundation

enum PageSide {
    
    case right, left
    
    var title: String {
        switch self {
        case .right: return "Right"
        case .left: return "Left"
        }
    }
    
}
