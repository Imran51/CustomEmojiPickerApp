//
//  EmojiModel.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import Foundation

struct Emoji: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

struct EmojiCategorySection: Identifiable, Hashable {
    static func == (lhs: EmojiCategorySection, rhs: EmojiCategorySection) -> Bool {
        lhs.id == rhs.id && lhs.category == rhs.category
    }
    
    let id = UUID()
    let category: EmojiCategory
    let emojis: [Emoji]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
    }
}
