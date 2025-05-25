//
//  JournalModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Foundation

struct JournalModel: Identifiable {
    var id: String = ""
    var userId: String = ""
    var date: Date
    var mood: MoodModel
    var title: String
    var content: String
}
