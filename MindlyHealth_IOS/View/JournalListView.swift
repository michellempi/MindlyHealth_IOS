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
    @State private var showingDeleteAlert = false
    @State private var journalToDelete: JournalModel? = nil
    @State private var searchText = ""
    

    var filteredJournals: [JournalModel] {
        if searchText.isEmpty {
            return journalVM.journals.sorted { $0.date > $1.date }
        } else {
            return journalVM.journals
                .filter { journal in
                    journal.title.localizedCaseInsensitiveContains(searchText) ||
                    journal.content.localizedCaseInsensitiveContains(searchText) ||
                    journal.mood.description.localizedCaseInsensitiveContains(searchText)
                }
                .sorted { $0.date > $1.date }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if journalVM.journals.isEmpty {
                   
                    EmptyJournalView {
                        showingAdd = true
                    }
                } else if filteredJournals.isEmpty && !searchText.isEmpty {
                   
                    NoSearchResultsView(searchText: searchText)
                } else {
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredJournals) { journal in
                                JournalCardView(
                                    journal: journal,
                                    onEdit: {
                                        editingJournal = journal
                                        showingAdd = true
                                    },
                                    onDelete: {
                                        journalToDelete = journal
                                        showingDeleteAlert = true
                                    }
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                    .refreshable {
                        
                        await refreshJournals()
                    }
                }
            }
            .navigationTitle("My Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !journalVM.journals.isEmpty {
                        Menu {
                            Button(action: {
                               
                            }) {
                                Label("Sort by Date", systemImage: "calendar")
                            }
                            
                            Button(action: {
                               
                            }) {
                                Label("Sort by Mood", systemImage: "face.smiling")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    
                    Button(action: {
                        editingJournal = nil
                        showingAdd = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAdd, onDismiss: {
                editingJournal = nil
            }) {
                AddJournalView(
                    journalVM: journalVM,
                    existingJournal: editingJournal
                )
            }
            .alert("Delete Journal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    journalToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let journal = journalToDelete {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            journalVM.deleteJournal(journal)
                        }
                    }
                    journalToDelete = nil
                }
            } message: {
                Text("This action cannot be undone. Are you sure you want to delete this journal entry?")
            }
        }
        .searchable(text: $searchText, prompt: "Search journals...")
        .onAppear {
           
        }
    }
    
  
    private func refreshJournals() async {
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
       
    }
}


struct EmptyJournalView: View {
    let onAddJournal: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.pages")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(.blue)
            }
            
           
            VStack(spacing: 8) {
                Text("Start Your Journal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Capture your thoughts, feelings, and daily experiences. Your first entry is just a tap away.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
         
            Button(action: onAddJournal) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Write Your First Entry")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(.blue, in: Capsule())
            }
            .buttonStyle(.plain)
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}



struct NoSearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 4) {
                Text("No Results Found")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("No journals match \"\(searchText)\"")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}


#Preview {
    JournalListView()
}
