//
//  JournalViewModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct JournalEntry: Identifiable, Codable {
    
    var id: String
    var title: String
    var content: String
    var timestamp: Double

    // Firebase-friendly initializer
    init(id: String = UUID().uuidString, title: String, content: String, timestamp: Double = Date().timeIntervalSince1970) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }

    init?(from snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let title = value["title"] as? String,
            let content = value["content"] as? String,
            let timestamp = value["timestamp"] as? Double
        else {
            return nil
        }

        self.id = snapshot.key
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }

    func toDict() -> [String: Any] {
        return [
            "title": title,
            "content": content,
            "timestamp": timestamp
        ]
    }
}

class JournalViewModel: ObservableObject {
    @Published var journalEntries: [JournalEntry] = []
    private var dbRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference().child("users").child(uid).child("journals")
    }
    
    init() {
        fetchJournalEntries()
    }
    
    @Published var journals: [JournalModel] = []
    
    func fetchJournalEntries() {
        dbRef?.observe(.value, with: { snapshot in
            var newEntries: [JournalEntry] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let entry = JournalEntry(from: childSnapshot) {
                    newEntries.append(entry)
                }
            }
            self.journalEntries = newEntries.sorted { $0.timestamp > $1.timestamp }
        })
    }
    
    func addEntry(title: String, content: String) {
        let newEntry = JournalEntry(title: title, content: content)
        dbRef?.child(newEntry.id).setValue(newEntry.toDict())
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        dbRef?.child(entry.id).removeValue()
    }
    
    
    func addJournal(title: String, content: String, mood: MoodModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let journal = JournalModel(
            userId: uid,
            date: Date(),
            mood: mood,
            title: title,
            content: content
        )
        
        dbRef?.child(journal.id).setValue(journal.toDict())
    }
}
