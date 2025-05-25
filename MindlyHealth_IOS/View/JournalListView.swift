//
//  JournalListView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct JournalListView: View {
    @StateObject private var journalVM = JournalViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(journalVM.journals) { journal in
                        JournalCardView(journal: journal)
                    }
                }
                .padding()
            }
            .navigationTitle("My Journal")
        }
    }
}

#Preview {
    JournalListView()
}
