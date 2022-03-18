//
//  Database+PathBuilderModification.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/17/22.
//

import Foundation
import GRDB

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
        
        /// A `Decodable` to representent a `PathBuilderNode` from `AppBook`
        /// Only these fields are relevent to use in analysis
        struct Node: Decodable {
            let contentId: Int
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let node = try container.decodeIfPresent(Node.self, forKey: .addNode) {
                self = .add(node: node)
            } else {
                self = .unknown
            }

        }
        
        static func generateCreationCount(ofTextItems: Bool, appbookId: AppBook.ID, pageNumber: Int, in database: GRDB.Database) throws -> Int? {
            
            // get the event descriptions for modifications, as these have the nodes created as JSON in the description
            let eventLogQuery = """
                SELECT \(Database.EventLog.Column.description)
                FROM \(Database.EventLog.tableName)
                WHERE \(Database.EventLog.Column.appbookId) = \(appbookId)
                AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                AND \(Database.EventLog.Column.code) = \(Database.PathBuilderModification.eventCode)
            """
            
            let rows = try Row.fetchCursor(database, sql: eventLogQuery)
            
            // keep a list of all the content ids from the decoded path builder nodes
            var createdContentIds = [Int]()
            
            while let row = try rows.next() {
                
                // attempt to convert the nodes to codable `PathBuilderModification` objects
                let description: String = row[Database.EventLog.Column.description]
                guard
                    let rawJSON = description.components(separatedBy: Database.PathBuilderModification.eventDescriptionPrefixText).last,
                    let data = rawJSON.data(using: .utf8)
                else {
                    continue
                }
                let modification = try JSONDecoder().decode(Database.PathBuilderModification.self, from: data)
                
                switch modification {
                case .add(node: let node):
                    createdContentIds.append(node.contentId)
                case .unknown:
                    continue
                }
                
            }
            
            guard createdContentIds.isEmpty == false else {
                return nil
            }
            
            let contentIdsString = createdContentIds.map(String.init).joined(separator: ",")
            
            // check how many nodes have content that is not text
            let studentProjectContentQuery = """
                SELECT COUNT(*)
                FROM \(Database.StudentProjectContent.tableName)
                WHERE \(Database.StudentProjectContent.Column.id) IN (\(contentIdsString))
                AND \(Database.StudentProjectContent.Column.contentType) \(ofTextItems ? "==" : "!=") '\(Database.StudentProjectContent.ContentType.text.rawValue)'
            """
            
            guard let count = try Int.fetchOne(database, sql: studentProjectContentQuery) else {
                return nil
            }
            
            return count
            
        }
        
    }
    
}
