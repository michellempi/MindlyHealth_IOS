//
//  JournalModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Foundation

struct JournalModel {
    var id: String = ""
    var userId: String = ""
    var date: Date
    var mood: MoodModel
    var content: String = ""
}
