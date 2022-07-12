//
//  MoviePlayTime.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/24/22.
//

import Foundation
import GRDB
import Regex
import AppBookAnalyticEvents

struct MoviePlayTime: Analytic {
        
    var title: String = "Movie Player - Play Time"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.appbookId) = \(appbook.id)
                    AND \(Database.EventLog.Column.pageNumber) = \(pageNumber)
                    AND (
                        \(Database.EventLog.Column.code) = \(AppBookAnalyticEvent.moviePlayerPlayed.code)
                        OR
                        \(Database.EventLog.Column.code) = \(AppBookAnalyticEvent.moviePlayerStopped.code)
                    )
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                let cursor = AnyCursor(rows)

                return try calculatePlaybackTime(forEvents: cursor)
                
                
            case .job(let job):
                
                let movieFileNameQuery = """
                    SELECT \(Database.VideoModal.Column.fileName)
                    FROM \(Database.VideoModal.tableName)
                    JOIN \(Database.Job.tableName)
                    ON \(Database.Job.tableName).\(Database.Job.Column.videoModalId)
                        = \(Database.VideoModal.tableName).\(Database.VideoModal.Column.id)
                    WHERE \(Database.Job.tableName).\(Database.Job.Column.id) = \(job.id)
                """

                guard let movieFileName = try String.fetchOne(db, sql: movieFileNameQuery) else {
                    return nil
                }
                
                let eventsQuery = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) = \(AppBookAnalyticEvent.moviePlayerPlayed.code)
                    OR \(Database.EventLog.Column.code) = \(AppBookAnalyticEvent.moviePlayerStopped.code)
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """
                
                let allMoviePlaybackEvents = try Row.fetchCursor(db, sql: eventsQuery)
                let jobMoviePlaybackEvents = allMoviePlaybackEvents.filter { row in
                    let description: String = row[Database.EventLog.Column.description]
                    return description.contains(movieFileName)
                }
                let cursor = AnyCursor(jobMoviePlaybackEvents)

                return try calculatePlaybackTime(forEvents: cursor)
                
            }
            
        }
        
    }
    
    /// Using the play/stop events to caculate the playback time for movies on a given page or for a job.
    /// Requires type-erasure (`AnyCursor`) since `Cursor` is a protocol with an associated type.
    private func calculatePlaybackTime(forEvents cursor: AnyCursor<Row>) throws -> String {
        
        var totalTime = 0.0
        var mostRecentStartTime: Double? = nil
        
        let regex = Regex(#"@-[0-9]*\.[0-9]*"#) // movie event descriptions include the time syntax @-#.###
                
        while let row = try cursor.next() {
            
            let code: Int = row[Database.EventLog.Column.code]
            let description: String = row[Database.EventLog.Column.description]
            
            guard let playheadRegexMatch: String = regex.firstMatch(in: description)?.value,
                  let timeString = playheadRegexMatch.components(separatedBy: "@-").last,
                  let playhead = Double(timeString) else {
                continue
            }
            
            if let startTime = mostRecentStartTime {
                
                totalTime += playhead - startTime
                mostRecentStartTime = nil
                
            } else if code == AppBookAnalyticEvent.moviePlayerPlayed.code {
                // if we don't have a mostRecentStartTime, save the playhead as mostRecentStartTime if it's for a play event code
                
                mostRecentStartTime = playhead
                
            } // if theres no mostRecentStartTime and we're not looking at a play event code, forget a stopped playing event code
            
        }
        
        
        return totalTime.formatted(.number.precision(.significantDigits(2)))
    }
    
}
