//
//  InputTextFieldView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct InputTextFieldView: View {
    let localizedTitle: String
    let localizedPlaceholder: String
    @Binding var text: String
    var isSecured: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autoCorrectionDisabled: Bool = false
    var submitLabel: SubmitLabel = .done
    var axis: Axis = .horizontal
    var lineLimit: Int? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(LocalizedStringKey(localizedTitle))
                .font(.headline)
            Group {
                if isSecured {
                    SecureField(
                        LocalizedStringKey(localizedPlaceholder),
                        text: $text
                    )
                } else {
                    TextField(
                        LocalizedStringKey(localizedPlaceholder),
                        text: $text,
                        axis: axis
                    )
                    .lineLimit(lineLimit)
                }
            }
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(autoCorrectionDisabled)
            .submitLabel(submitLabel)
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
        localizedTitle: "Email address",
        localizedPlaceholder: "Enter your email address",
        text: $text,
        keyboardType: .emailAddress
    )
}
