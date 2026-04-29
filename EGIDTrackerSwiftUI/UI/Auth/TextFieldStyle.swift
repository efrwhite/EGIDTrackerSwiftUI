//
//  TextFieldStyle.swift
//  EGID Tracker
//
//  Created by dafni on 3/20/26.
//

import SwiftUI

struct VectorIconField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboard: UIKeyboardType = .default

    @State private var showPassword: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color("PrimaryColor"))
                .frame(width: 25)

            Group {
                if isSecure && !showPassword {
                    SecureField(
                        placeholder,
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(Color("PrimaryColor"))
                    )
                } else {
                    TextField(
                        placeholder,
                        text: $text,
                        prompt: Text(placeholder).foregroundColor(Color("PrimaryColor"))
                    )
                }
            }

            if isSecure {
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("SecondaryColor").opacity(0.09))
        )
        .keyboardType(keyboard)
        .padding(.horizontal, 10)
    }
}
