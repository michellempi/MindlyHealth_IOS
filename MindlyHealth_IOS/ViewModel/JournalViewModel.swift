//
//  JournalViewModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Foundation

class JournalViewModel: ObservableObject {
    @Published var journals: [JournalModel] = []

    init() {
        loadDummyJournals()
    }

    func loadDummyJournals() {
        journals = [
            JournalModel(
                id: UUID().uuidString,
                userId: "user1",
                date: Date(),
                mood: MoodModel(
                    id: "mood1",
                    description: "Happy",
                    emoji: "😊"
                ),
                title: "Great Start",
                content: "I had a great start to the day!"
            ),
            JournalModel(
                id: UUID().uuidString,
                userId: "user2",
                date: Date().addingTimeInterval(-86400),
                mood: MoodModel(
                    id: "mood2",
                    description: "Sad",
                    emoji: "😢"
                ),
                title: "Tough Day",
                content:
                    "Today was a bit tough emotionally, but I’m trying to get through it."
            ),
        ]
    }
}
