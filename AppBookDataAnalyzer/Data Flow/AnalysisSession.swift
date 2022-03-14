//
//  AnalysisSession.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

/// Manages writing data to a CSV in-memory and when complete, writes the output to a CSV file
actor AnalysisSession {
    
    /// The representation of a cell in the final output CSV
    struct Entry {
        let analysisResult: String?
        let textbookMaterial: TextbookMaterial
        let analytic: Analytic
    }
    
    /// Utility dictionary to speed up col lookup in `write()`
    private let textbookMaterialToColumnIndicies: [TextbookMaterial: Int]
    
    /// Utility dictionary to speed up row lookup in `write()`
    private let analyticsToRowIndicies: [String: Int]
    
    /// The underlying storage for the output. The outer array represents rows (analytics) and the inner arrays represent columns (pages and job) for each row
    private var storage: [[String]]
    
    private let curriculum: Curriculum
    
    /// A working area for keeping track of the results of `Analytic` queries
    /// - Parameters:
    ///   - curriculum: The curriculum that will be used to organize the columns (`curriculum.textbookMaterial`) and the rows (`curriculum.analytics`)
    init(curriculum: Curriculum) {
        
        self.curriculum = curriculum
        
        let columns = [String](repeating: "", count: curriculum.textbookMaterials.count)
        storage = [[String]](repeating: columns, count: curriculum.analytics.count)
        
        textbookMaterialToColumnIndicies = curriculum.textbookMaterials.indices.reduce([TextbookMaterial: Int](), { partialResult, index in
            let textbookMaterial = curriculum.textbookMaterials[index]
            var mutableResult = partialResult
            mutableResult[textbookMaterial] = index
            return mutableResult
        })
        
        analyticsToRowIndicies = curriculum.analytics.indices.reduce([String: Int](), { partialResult, index in
            let analytic = curriculum.analytics[index]
            var mutableResult = partialResult
            mutableResult[analytic.title] = index
            return mutableResult
        })
        
    }
    
    /// Appends an entry to the current row
    func write(entry: Entry) {
        
        guard let rowIndex = analyticsToRowIndicies[entry.analytic.title],
              let colIndex = textbookMaterialToColumnIndicies[entry.textbookMaterial]
        else {
            print("Correct cell couldn't be found in storage for \(entry.analytic.title) for \(entry.textbookMaterial)")
            return
        }
        
        storage[rowIndex][colIndex] = entry.analysisResult ?? ""
        
    }
    
    /// Writes the `output` to a CSV on disk
    func exportCSV(named fileName: String) -> URL? {
        
        let cellSeperator = ","
        let lineSeperator = "\n"
        
        let textbookMaterialTitles = curriculum.textbookMaterials
            .map(\.title)
            .joined(separator: cellSeperator)
        
        let header = "Analytics" + cellSeperator + textbookMaterialTitles
        
        let individualRows: [String] = curriculum.analytics.indices.map { rowIndex in
            
            let analyticTitle = curriculum.analytics[rowIndex].title
            
            let rowCells = storage[rowIndex].joined(separator: cellSeperator)
            
            return analyticTitle + cellSeperator + rowCells
            
        }
        
        let rows = individualRows.joined(separator: lineSeperator)
        
        let output = header + lineSeperator + rows
        
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName).csv")
        
        do {
            
            try output.write(to: outputURL, atomically: true, encoding: String.Encoding.utf8)
            return outputURL
            
        } catch {
            
            print(error.localizedDescription)
            return nil
            
        }
        
        
        
    }
    
}
