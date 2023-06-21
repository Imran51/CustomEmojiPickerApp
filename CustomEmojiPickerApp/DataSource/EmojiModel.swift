//
//  EmojiModel.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import Foundation

struct Emoji: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let value: String
    let category: EmojiCategory
    let aliases: [String]
    let tags: [String]
    let unicodeVersion: String
    let iosVersion: String
    
    init(name: String, value: String, category: EmojiCategory = .preview, aliases: [String]  = [], tags: [String] = [], unicodeVersion: String = "", iosVersion: String = "") {
        self.name = name
        self.value = value
        self.category = category
        self.aliases = aliases
        self.tags = tags
        self.unicodeVersion = unicodeVersion
        self.iosVersion = iosVersion
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "description"
        case value = "emoji"
        case category
        case aliases
        case tags
        case unicodeVersion = "unicode_version"
        case iosVersion = "ios_version"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(String.self, forKey: .value)
        let categoryStr = try container.decode(String.self, forKey: .category)
        self.category = EmojiCategory(rawValue: categoryStr) ?? .smileysAndPeople
        self.aliases = try container.decode([String].self, forKey: .aliases)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.unicodeVersion = try container.decode(String.self, forKey: .unicodeVersion)
        self.iosVersion = try container.decode(String.self, forKey: .iosVersion)
    }
    
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
