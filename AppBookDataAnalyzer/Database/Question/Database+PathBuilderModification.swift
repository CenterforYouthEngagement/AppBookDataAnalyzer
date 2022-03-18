//
//  Database+PathBuilderModification.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation

extension Database {
    
    /// A `Decodable` version of a `PathBuilderModification` modification from `AppBoook`
    /// The node/link modifications are stored in raw JSON in the `event_log`
    enum PathBuilderModification: Decodable {
        
        static let eventCode = 28
        
        /// The prefix text in the `event_log.description` field for this event type. This needs to be removed to get at the raw JSON
        static let eventDescriptionPrefixText = "pathBuilderModificationCreated - "
        
        case add(node: Node)
        case unknown
        
        enum CodingKeys: String, CodingKey {
            case addNode
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let node = try container.decodeIfPresent(Node.self, forKey: .addNode) {
                self = .add(node: node)
            } else {
                self = .unknown
            }

        }
        
    }

    /// A `Decodable` to representent a `PathBuilderNode` from `AppBook`
    /// Only these fields are relevent to use in analysis
    struct Node: Decodable {
        let contentId: Int
    }
    
    
    
}
