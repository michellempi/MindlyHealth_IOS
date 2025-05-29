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
    @State private var editingJournal: JournalModel? = nil

    var body: some View {
        NavigationView {
            VStack {
                if journalVM.journals.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("You have no journals")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Start by adding a new journal entry!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(journalVM.journals) { journal in
                                JournalCardView(
                                    journal: journal,
                                    onEdit: {
                                        editingJournal = journal
                                        showingAdd = true
                                    },
                                    onDelete: {
                                        journalVM.deleteJournal(journal)
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
                AddJournalView(
                    journalVM: journalVM,
                    existingJournal: editingJournal
                )
            }
        }
    }
}
