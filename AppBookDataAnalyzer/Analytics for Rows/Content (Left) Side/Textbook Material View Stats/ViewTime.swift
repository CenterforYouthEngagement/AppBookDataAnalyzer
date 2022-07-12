//
//  ViewTime.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 3/10/22.
//

import Foundation
import GRDB
import Regex
import AppBookAnalyticEvents

struct ViewTime: Analytic {
    
    let pageOpenedEventCode = AppBookAnalyticEvent.pageOpened.code
    let pageClosedEventCode = AppBookAnalyticEvent.pageClosed.code
    let jobOpenedEventCode = AppBookAnalyticEvent.exploredJob.code
    let jobClosedEventCode = AppBookAnalyticEvent.closedJob.code
    let appBackgrounded = AppBookAnalyticEvent.appEnteringBackground.code
    let appReturnedFromBackground = AppBookAnalyticEvent.appReturningFromBackground.code
    let appShutDown = AppBookAnalyticEvent.appShutDown.code
    
    private var pageEventCodes: String {
        [pageOpenedEventCode, pageClosedEventCode, appBackgrounded, appReturnedFromBackground, appShutDown]
            .map(String.init)
            .joined(separator: ",")
    }
    
    private var jobSpecificEventCodes: String {
        [jobOpenedEventCode, jobClosedEventCode]
            .map(String.init)
            .joined(separator: ",")
    }
    
    private var jobClosingEventCodes: String {
        [pageClosedEventCode, appBackgrounded, appReturnedFromBackground, appShutDown]
            .map(String.init)
            .joined(separator: ",")
    }
    
    var title: String = "Time Viewing"
    
    func analyze(database: Database, textbookMaterial: TextbookMaterial) async -> String? {
        
        try? await database.queue.read { db in 
            
            switch textbookMaterial {
                
            case .page(let appbook, let pageNumber):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) IN (\(pageEventCodes))
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """
                
                let allEvents = try Row.fetchCursor(db, sql: query)
                
                // Expected page open/close description syntax for this page
                // Can't use the `event_log.page_number` since this page could be viewed from another page (modally)
                let regex = try Regex("a-\(appbook.id) p-\(pageNumber)$")
                
                // only check the events that aren't app backgrounding related for page number matching
                let instantApprovals = [appBackgrounded, appReturnedFromBackground, appShutDown]
                
                let relevantEvents = allEvents.filter { row in
                    if instantApprovals.contains(row[Database.EventLog.Column.code]) {
                        return true
                    } else {
                        return regex.isMatched(by: row[Database.EventLog.Column.description])
                    }
                }
                
                // The total time that has been spent on this page
                var totalTime: TimeInterval = 0.0
                
                var currentOpenDate: Date?
                
                while let row = try relevantEvents.next() {
                    
                    let eventCode: Int = row[Database.EventLog.Column.code]
                    
                    let timestamp: Double = row[Database.EventLog.Column.timestamp]
                    let rowDate = Date(timeIntervalSince1970: timestamp)
                    
                    // if there is no currently open date, set the current open date to this row's date,
                    // if its event code is the page open code
                    guard let openDate = currentOpenDate else {
                        if eventCode == pageOpenedEventCode {
                            currentOpenDate = rowDate
                        }
                        continue
                    }
                    
                    switch eventCode {
                        
                    // when there's an open date and any of the below are seen, calculate the time on page and nullify the current open date
                    case pageOpenedEventCode, pageClosedEventCode, appShutDown:
                        totalTime += openDate.distance(to: rowDate)
                        currentOpenDate = nil
                        continue
                        
                    // when the app is backgrounded, add the time on page before backgrounding
                    // but keep this open date so that when the app returns, we reset the open time to that time
                    // since this page will be open
                    case appBackgrounded:
                        totalTime += openDate.distance(to: rowDate)
                        continue
                        
                    // when the app returns and theres a current open date, reset the date to this rows time
                    // since the user wasn't looking at this page when the app was backgrounded
                    case appReturnedFromBackground:
                        currentOpenDate = rowDate
                        continue
                        
                    default:
                        continue
                        
                    }
                    
                }
                
                return String(totalTime)
                
                
            case .job(let job):
                
                let query = """
                    SELECT *
                    FROM \(Database.EventLog.tableName)
                    WHERE \(Database.EventLog.Column.code) IN (\(jobClosingEventCodes))
                    OR (
                        \(Database.EventLog.Column.code) IN (\(jobSpecificEventCodes))
                        AND
                        \(Database.EventLog.Column.contextId) = \(job.id)
                    )
                    ORDER BY \(Database.EventLog.Column.timestamp) ASC
                """
                
                let rows = try Row.fetchCursor(db, sql: query)
                
                // The total time that has been spent on this page
                var totalTime: TimeInterval = 0.0
                
                var currentOpenDate: Date?
                
                while let row = try rows.next() {
                    
                    let eventCode: Int = row[Database.EventLog.Column.code]
                    
                    let timestamp: Double = row[Database.EventLog.Column.timestamp]
                    let rowDate = Date(timeIntervalSince1970: timestamp)
                    
                    // if there is no currently open date, set the current open date to this row's date,
                    // if its event code is the page open code
                    guard let openDate = currentOpenDate else {
                        if eventCode == jobOpenedEventCode {
                            currentOpenDate = rowDate
                        }
                        continue
                    }
                    
                    switch eventCode {
                        
                    // when there's an open date and any of the below are seen, calculate the time job's open and nullify the current open date
                    case jobOpenedEventCode, jobClosedEventCode, pageClosedEventCode, appShutDown:
                        totalTime += openDate.distance(to: rowDate)
                        currentOpenDate = nil
                        continue
                        
                    // when the app is backgrounded, add the time viewing job before backgrounding
                    // but keep this open date so that when the app returns, we reset the open time to that time
                    // since this job will be open
                    case appBackgrounded:
                        totalTime += openDate.distance(to: rowDate)
                        continue
                        
                    // when the app returns and theres a current open date, reset the date to this rows time
                    // since the user wasn't looking at this job when the app was backgrounded
                    case appReturnedFromBackground:
                        currentOpenDate = rowDate
                        continue
                        
                    default:
                        continue
                        
                    }
                    
                }
                
                return String(totalTime)
                
            }
            
            
        }
        
    }
    
    
}
