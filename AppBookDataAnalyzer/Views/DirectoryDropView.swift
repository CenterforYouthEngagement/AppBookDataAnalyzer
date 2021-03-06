//
//  DirectoryDropView.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import SwiftUI

struct DirectoryDropView: View {
    
    let dropAreaLength: CGFloat = 300
    
    var dropDelegate: DirectoryDropDelegate
    
    var body: some View {
        Text("Drop iPad Documents Directory Here!")
            .font(.title)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
            .frame(width: dropAreaLength, height: dropAreaLength)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.accentColor)
                    .opacity(0.6)
            )
            .frame(width: dropAreaLength * 1.5, height: dropAreaLength * 1.5)
            .onDrop(of: [.fileURL], delegate: dropDelegate)
            
    }
}

struct DirectoryDropView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryDropView(dropDelegate: DirectoryDropDelegate())
    }
}
