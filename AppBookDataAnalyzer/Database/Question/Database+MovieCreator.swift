//
//  Database+MovieCreator.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/18/22.
//

import Foundation
import GRDB

extension Database {
    
    /// A `Decodable` version of a `MovieCreatorModification` modification from `AppBoook`
    /// The slide modifications are stored in raw JSON in the `event_log`
    enum MovieCreatorModification: Decodable {
        
        static let eventCode = 31
        
        /// The prefix text in the `event_log.description` field for this event type. This needs to be removed to get at the raw JSON
        static let eventDescriptionPrefixText = "movieCreatorModificationCreated - "
        
        case add(slide: Slide)
        case slide(modification: SlideModification)
        case unknown
        
        enum CodingKeys: String, CodingKey {
            case addSlide
            case modifiedSlide = "slideModification"
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let slide = try container.decodeIfPresent(Slide.self, forKey: .addSlide) {
                self = .add(slide: slide)
            } else if let modification = try container.decodeIfPresent(SlideModification.self, forKey: .modifiedSlide) {
                self = .slide(modification: modification)
            } else {
                self = .unknown
            }
            
        }
        
        struct Slide: Decodable {
            let id: Int
        }
        
        enum SlideModification: Decodable {
            
            case template(from: Template, to: Template)
            case narrationTo(_: String)
            case narration(from: String, to: String)
            case themeTo(_: Theme)
            case unknown
            
            enum CodingKeys: String, CodingKey {
                case narrationFrom, narrationTo
                case themeTo
                case templateFrom, templateTo
            }
            
            init(from decoder: Decoder) throws {
                
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                if let lhsTemplate = try container.decodeIfPresent(Template.self, forKey: .templateFrom),
                   let rhsTemplate = try container.decodeIfPresent(Template.self, forKey: .templateTo) {
                    self = .template(from: lhsTemplate, to: rhsTemplate)
                } else if let theme = try container.decodeIfPresent(Theme.self, forKey: .themeTo) {
                    self = .themeTo(theme)
                } else if let narrationFrom = try container.decodeIfPresent(String.self, forKey: .narrationFrom),
                          let narrationTo = try container.decodeIfPresent(String.self, forKey: .narrationTo) {
                    self = .narration(from: narrationFrom, to: narrationTo)
                } else if let narrationTo = try container.decodeIfPresent(String.self, forKey: .narrationTo) {
                    self = .narrationTo(narrationTo)
                } else {
                    self = .unknown
                }
                
            }
            
            var addedContentId: Int? {
                switch self {
                case .template(from: .empty, to: .single(centerContentId: let centeredContentId)):
                    return centeredContentId
                case .template(from: Template.single(_), to: Template.dual(_, let rightContentId)):
                    return rightContentId
                default:
                    return nil
                }
            }
            
        }
        
        enum Template: Decodable {
            
            case single(centerContentId: Int)
            case dual(leftContentId: Int, rightContentId: Int)
            case empty
            
            enum CodingKeys: String, CodingKey {
                case centerContentId
                case leftContentId, rightContentId
            }
            
            init(from decoder: Decoder) throws {
                
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                if let centerContentId = try container.decodeIfPresent(Int.self, forKey: .centerContentId) {
                    self = .single(centerContentId: centerContentId)
                } else if let leftContentId = try container.decodeIfPresent(Int.self, forKey: .leftContentId),
                          let rightContentId = try container.decodeIfPresent(Int.self, forKey: .rightContentId) {
                    self = .dual(leftContentId: leftContentId, rightContentId: rightContentId)
                } else {
                    self = .empty
                }
                
            }
            
        }
        
        struct Theme: Decodable {
            let id: String
        }
        
        static func count(ofContentType contentType: StudentProjectContent.ContentType, appbookId: AppBook.ID, pageNumber: Int, in database: GRDB.Database) throws -> Int {
            
            let rows = try eventLogRows(appbookId: appbookId, pageNumber: pageNumber, in: database)
            
            // keep a list of all the content ids from the decoded path builder nodes
            var createdContentIds = [Int]()
            
            while let row = try rows.next() {
                
                let modification = try modification(from: row)
                
                switch modification {
                case .slide(modification: let modification):
                    guard let newContentId = modification.addedContentId else { continue }
                    createdContentIds.append(newContentId)
                default:
                    continue
                }
                
            }
            
            guard createdContentIds.isEmpty == false else {
                return 0
            }
            
            let contentIdsString = createdContentIds.map(String.init).joined(separator: ",")
            
            // check how many nodes have content that is not text
            var studentProjectContentQuery = """
                SELECT COUNT(*)
                FROM \(Database.StudentProjectContent.tableName)
                WHERE \(Database.StudentProjectContent.Column.id) IN (\(contentIdsString))
                AND \(Database.StudentProjectContent.Column.contentType)
            """
            
            if contentType == .other { // if other is the type, need to exclude all student project types
                
                let allNonOtherContentTypes = StudentProjectContent.ContentType.allCases
                                                    .filter { $0 != .other }
                                                    .map { "'" + $0.rawValue + "'" }
                                                    .joined(separator: ",")
                    
                
                studentProjectContentQuery += " NOT IN (\(allNonOtherContentTypes))"
                
            } else {
                
                studentProjectContentQuery +=  " == '\(contentType.rawValue)'"
                
            }
            
            guard let count = try Int.fetchOne(database, sql: studentProjectContentQuery) else {
                return 0
            }
            
            return count
            
        }
        
        enum CountableModification {
            case theme, narration, addSlide
        }
        
        static func count(ofModificationType modificationType: CountableModification, appbookId: AppBook.ID, pageNumber: Int, in database: GRDB.Database) throws -> Int {
            
            let rows = try eventLogRows(appbookId: appbookId, pageNumber: pageNumber, in: database)
            
            // keep a list of all the content ids from the decoded path builder nodes
            var count = 0
            
            while let row = try rows.next() {
                
                let modification = try modification(from: row)
                
                switch modification {
                case .slide(modification: SlideModification.themeTo(_))
                    where modificationType == .theme:
                    
                    count += 1
                    
                case .slide(modification: .narrationTo(_))
                    where modificationType == .narration:
                    
                    count += 1
                    
                case .slide(modification: .narration(from: _, to: _))
                    where modificationType == .narration:
                    
                    count += 1
                    
                case .add(slide: _)
                    where modificationType == .addSlide:
                    
                    count += 1
                    
                default:
                    continue
                }
                
            }
            
            return count
            
        }
        
        private static func eventLogRows(appbookId: AppBook.ID, pageNumber: Int, in database: GRDB.Database) throws -> RowCursor {
            
            // get the event descriptions for modifications, as these have the nodes created as JSON in the description
            let eventLogQuery = """
                SELECT \(Database.EventLog.Column.description)
                FROM \(Database.EventLog.tableName)
                WHERE \(Database.EventLog.Column.appbookId) = \(appbookId)
                AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                AND \(Database.EventLog.Column.code) = \(eventCode)
            """
            
            return try Row.fetchCursor(database, sql: eventLogQuery)
            
        }
        
        private static func modification(from row: RowCursor.Element) throws -> MovieCreatorModification? {
            
            // attempt to convert the nodes to codable `PathBuilderModification` objects
            let description: String = row[Database.EventLog.Column.description]
            guard
                let rawJSON = description.components(separatedBy: eventDescriptionPrefixText).last,
                let data = rawJSON.data(using: .utf8)
            else {
                return nil
            }
            
            return try JSONDecoder().decode(MovieCreatorModification.self, from: data)
            
        }
        
    }
    
}
