//
//  ProfilesFieldStyle.swift
//  EGID Tracker
//
//  Created by dafni on 4/9/26.
//

import SwiftUI

struct FieldTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 17))
            .fontWeight(.bold)
            .foregroundColor(Color("SecondaryColor"))
            .padding(0)
    }
}


struct ProfileInputField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(Color("SecondaryColor"))
            
            VStack(spacing: 0) {
                TextField("", text: $text)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("SecondaryColor"))
            }
        }
    }
}

struct BirthDatePartField: View {
    let placeholder: String
    @Binding var text: String
    let limit: Int
    var focusKey: Int
    @FocusState.Binding var activeField: Int?
    var nextFocusKey: Int?
    var width: CGFloat = 50

    var body: some View {
        VStack(spacing: 5) {
            Text(placeholder == "YYYY" ? "Year" : placeholder == "MM" ? "Month" : "Day")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 0) {
                TextField(placeholder, text: $text)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: width)
                    .padding(.top, 5)
                    .padding(.bottom, 3)
                    .focused($activeField, equals: focusKey)
                    .onChange(of: text) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        text = String(filtered.prefix(limit))
                        if text.count == limit, let next = nextFocusKey {
                            activeField = next
                        }
                    }
              Rectangle()
                    .frame(width: width, height: 1)
                    .foregroundColor(Color("SecondaryColor"))
                        
            }
            .background(Color(.systemGray6))
        }
    }
}
