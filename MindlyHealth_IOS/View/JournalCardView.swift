//
//  JournalCardView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 25/05/25.
//

import SwiftUI

struct JournalCardView: View {
    var journal: JournalModel
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text(journal.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text(journal.title)
                .font(.title3)
                .fontWeight(.semibold)

            HStack(spacing: 8) {
                Text("Your mood:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(journal.mood.emoji)
                    .font(.title2)

                Text(journal.mood.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text(journal.content)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)

            Divider()

            HStack {
                Spacer()
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption)
                }
                .buttonStyle(.bordered)

                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

