//
//  ListItemNavigationLinkView.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI

struct ListItemNavigationLinkView<Content: View>: View {
    let systemName: String
    let localizedText: String
    @ViewBuilder let destination: Content
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                HStack(spacing: 8.0) {
                    Image(systemName: systemName)
                        .imageScale(.large)
                        .frame(width: 40.0)
                    Text(LocalizedStringKey(localizedText))
                }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding(.vertical, 4.0)
        }
        .navigationLinkIndicatorVisibility(.hidden)
    }
}

#Preview {
    NavigationStack {
        ListItemNavigationLinkView(systemName: "person", localizedText: "Account") {
            
        }
    }
}
