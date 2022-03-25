//
//  JobFavoritedCount.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation
import GRDB

struct JobFavoritedCount: Analytic {
        
    var title: String = "Job - Favorite Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            guard let count = try JobFavoriteStatus.count(isFavorited: true, for: textbookMaterial, in: db) else {
                return nil
            }
            
            return String(count)
            
        }
        
    }
    
}

struct JobUnfavoritedCount: Analytic {
        
    var title: String = "Job - Unfavorited Count"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.pool.read { db in
            
            guard let count = try JobFavoriteStatus.count(isFavorited: false, for: textbookMaterial, in: db) else {
                return nil
            }
            
            return String(count)
            
        }
        
    }
    
}

private struct JobFavoriteStatus {
    
    static let jobFavoritedEventCode = 41
    
    static let favoritedEventPrefix = "jobFavorited -"
    
    static func count(isFavorited: Bool, for textbookMaterial: TextbookMaterial, in database: GRDB.Database) throws -> Int? {
        
        switch textbookMaterial {
            
        case .page(let appbook, let pageNumber):
            
            let query = """
                SELECT COUNT(*)
                FROM \(Database.EventLog.tableName)
                WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                AND \(Database.EventLog.Column.code) = \(jobFavoritedEventCode)
                AND \(Database.EventLog.Column.description) = '\(favoritedEventPrefix) \(isFavorited)'
            """
            
            guard let count = try Int.fetchOne(database, sql: query) else {
                return nil
            }
            
            return count
            
            
        case .job(let job):
            
            let query = """
                SELECT COUNT(*)
                FROM \(Database.EventLog.tableName)
                WHERE \(Database.EventLog.Column.code) = \(jobFavoritedEventCode)
                AND \(Database.EventLog.Column.contextId) = \(job.id)
                AND \(Database.EventLog.Column.description) = '\(favoritedEventPrefix) \(isFavorited)
            """
            
            guard let count = try Int.fetchOne(database, sql: query) else {
                return nil
            }
            
            return count
            
        }
        
    }
    
}
