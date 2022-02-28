//
//  CSVOutput.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation
// TODO - import SwiftCSV

/// Manages writing data to a CSV in-memory and when complete, writes the output to a CSV file
/// After init, should call (in this order):
/// 1. `prepareColumnHeaders(for:)` to write the column headers for the curriculum being analyzed
/// 2. `startNewRow(named:)` to start a new row with a row name
/// 3. `add(entry:)` to append an entry to the current row. This API only allows adding entries to rows in order by column
/// 4. `finishCurrentRow()` to close out the current row
/// 5. Repeat 2-4 for all the rows desired
/// 6. `writeCSVToDisk()` to write the output to disk in a CSV file
class CSVOutput {
    
    /// The contents of the CSV we're building
    var output: String = ""
    
    /// The sperator used to create a CSV
    private let seperator = ","
    
    init() { }
    
    /// Start the analysis by preparing the output. Since this is a CSV, write the column headers.
    func prepareColumnHeaders(for curriculum: Curriculum) {
        let columnHeaders = curriculum.columns.map(\.title)
        output = columnHeaders.joined(separator: seperator)
    }
    
    /// Should be called after `finishCurrentRow` is called. Starts a new line in the CSV with the row name of `rowName`
    func startNewRow(named rowName: String) {
        output += "\n\(rowName)"
    }
    
    /// Appends an entry to the current row
    func add(entry: String) {
        output += "\(seperator)\(entry)"
    }
    
    /// Writes the `output` to a CSV on disk
    func writeCSVToDisk() -> URL? {
        return nil // TODO - use SwiftCSV to write this output to a URL on disk 
    }
    
}
