//
//  SearchBar.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField(
                "Search jobs or company",
                text: $text
            )

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding()
    }
}
