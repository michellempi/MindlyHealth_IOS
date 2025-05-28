//
//  JournalModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Foundation
import FirebaseDatabase

struct JournalModel: Identifiable {
    var id: String
    var userId: String
    var date: Date
    var mood: MoodModel
    var title: String
    var content: String

    init(id: String = UUID().uuidString, userId: String = "", date: Date = Date(), mood: MoodModel, title: String, content: String) {
        self.id = id
        self.userId = userId
        self.date = date
        self.mood = mood
        self.title = title
        self.content = content
    }

    init?(from snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let userId = value["userId"] as? String,
            let title = value["title"] as? String,
            let content = value["content"] as? String,
            let timestamp = value["timestamp"] as? Double,
            let moodDict = value["mood"] as? [String: String],
            let moodId = moodDict["id"],
            let moodDescription = moodDict["description"],
            let moodEmoji = moodDict["emoji"]
        else {
            return nil
        }

        self.id = snapshot.key
        self.userId = userId
        self.title = title
        self.content = content
        self.date = Date(timeIntervalSince1970: timestamp)
        self.mood = MoodModel(id: moodId, description: moodDescription, emoji: moodEmoji)
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "title": title,
            "content": content,
            "timestamp": date.timeIntervalSince1970,
            "mood": [
                "id": mood.id,
                "description": mood.description,
                "emoji": mood.emoji
            ]
        ]
    }
}
