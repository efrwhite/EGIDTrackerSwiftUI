//
//  JournalView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Journal")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Coming soon")
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
    }
}
