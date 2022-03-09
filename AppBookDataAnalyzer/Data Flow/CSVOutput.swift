//
//  CSVOutput.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation
import OrderedCollections

/// Manages writing data to a CSV in-memory and when complete, writes the output to a CSV file
class CSVOutput {
    
    /// Utility dictionary to speed up col lookup in `write()`
    let textbookMaterialToColumnIndicies: [TextbookMaterial: Int]
    
    /// Utility dictionary to speed up row lookup in `write()`
    let analyticsToRowIndicies: [String: Int]
    
    /// The underlying storage for the output. The outer array represents rows (analytics) and the inner arrays represent columns (pages and job) for each row
    private var storage: [[String]]
    
    let curriculum: Curriculum
    
    /// The title to be used for the output of the data analysis
    let outputTitle: String
    
    /// Creates a CSV
    /// - Parameters:
    ///   - curriculum: The curriculum that will be used to organize the columns (`curriculum.textbookMaterial`) and the rows (`curriculum.analytics`)
    ///   - outputTitle: The name of the output CSV file (not including file extension)
    init(curriculum: Curriculum, outputTitle: String) {
        
        self.curriculum = curriculum
        self.outputTitle = outputTitle
        
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
    func write(entry: String?, textbookMaterial: TextbookMaterial, analytic: Analytic) {
        
        guard let rowIndex = analyticsToRowIndicies[analytic.title],
              let colIndex = textbookMaterialToColumnIndicies[textbookMaterial]
        else {
            print("Correct cell couldn't be found in storage for \(analytic.title) for \(textbookMaterial)")
            return
        }
        
        storage[rowIndex][colIndex] = entry ?? ""
        
    }
    
    /// Writes the `output` to a CSV on disk
    func writeCSVToDisk() -> URL? {
        
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
        
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(outputTitle).csv")
        
        do {
            
            try output.write(to: outputURL, atomically: true, encoding: String.Encoding.utf8)
            return outputURL
            
        } catch {
            
            print(error.localizedDescription)
            return nil
            
        }
        
        
        
    }
    
}
