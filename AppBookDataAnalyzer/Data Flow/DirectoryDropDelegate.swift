//
//  DirectoryDropDelegate.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import SwiftUI
import UniformTypeIdentifiers

class DirectoryDropDelegate: DropDelegate {
    
    var urlHandler: ((URL) -> Void)? = nil
    
    func validateDrop(info: DropInfo) -> Bool {
        
        print("New drop incoming...")
        
        guard info.hasItemsConforming(to: [.directory]) else {
            print("It was a file")
            return false
        }
        
        print("It was a directory")
        
        return true
        
    }
    
    func performDrop(info: DropInfo) -> Bool {
        
        // TODO - maybe we can support dropping multiple iPad directories if we don't call `.first`
        guard let directory = info.itemProviders(for: [.directory]).first else {
            print("No directories found in the drag")
            return false
        }
        
        directory.loadItem(forTypeIdentifier: UTType.directory.identifier) { (urlData, error) in
            
            if let error = error {
                print("Error loading directory: \(error.localizedDescription)")
                return
            }
            
            guard let urlData = urlData as? Data else {
                print("Data loaded from item provider couldn't be found")
                return
            }
            
            guard let url = URL(dataRepresentation: urlData, relativeTo: nil) else {
                print("Couldn't find url in item provider's data")
                return
            }
            
            self.urlHandler?(url)
            
        }
        
        
        return true
        
    }
    
}
