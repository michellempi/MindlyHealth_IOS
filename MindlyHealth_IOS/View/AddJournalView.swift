//
//  AddJournalView.swift
//  MindlyHealth_IOS
//
//  Created by student on 28/05/25.
//
import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var journalVM: JournalViewModel

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedMood: MoodModel = MoodModel(id: "happy", description: "Happy", emoji: "😊")
    var existingJournal: JournalModel? = nil

    let moods: [MoodModel] = [
        .init(id: "happy", description: "Happy", emoji: "😊"),
        .init(id: "sad", description: "Sad", emoji: "😢"),
        .init(id: "angry", description: "Angry", emoji: "😠"),
        .init(id: "anxious", description: "Anxious", emoji: "😰")
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Mood")) {
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.id) { mood in
                            HStack {
                                Text(mood.emoji)
                                Text(mood.description)
                            }
                            .tag(mood)
                        }
                    }
                }

                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 150)
                }
            }
            .navigationTitle(existingJournal == nil ? "New Journal" : "Edit Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let journal = existingJournal {
                            journalVM.updateJournal(
                                journal,
                                newTitle: title,
                                newContent: content,
                                newMood: selectedMood
                            )
                        } else {
                            journalVM.addJournal(
                                title: title,
                                content: content,
                                mood: selectedMood
                            )
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onAppear {
                if let journal = existingJournal {
                    title = journal.title
                    content = journal.content
                    selectedMood = journal.mood
                }
            }
        }
    }
}

#Preview {
    AddJournalView(journalVM: JournalViewModel())
}
