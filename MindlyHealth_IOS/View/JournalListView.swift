//
//  JournalListView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct JournalListView: View {
    @StateObject private var journalVM = JournalViewModel()
    @State private var showingAdd = false

    var body: some View {
        NavigationView {
            VStack {
                if journalVM.journals.isEmpty {
                    Spacer()
                    ProgressView("Loading Journals...")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(journalVM.journals) { journal in
                                JournalCardView(
                                    journal: journal,
                                    onDelete: {
                                        $journalVM.deleteJournal(journal)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAdd = true
                    }) {
                        Label("Add Journal", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddJournalView(journalVM: journalVM)
            }
        }
    }
}

