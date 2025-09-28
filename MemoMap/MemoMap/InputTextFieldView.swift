//
//  InputTextFieldView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct InputTextFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecured: Bool = false
    var axis: Axis = .horizontal
    var lineLimit: Int? = nil
    var height: CGFloat? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title)
                .font(.headline)
            Group {
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text, axis: axis)
                        .lineLimit(lineLimit)
                        .frame(height: height, alignment: .top)
                }
            }
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    InputTextFieldView(
        title: "Email address",
        placeholder: "Enter your email address",
        text: $text,
    )
}
