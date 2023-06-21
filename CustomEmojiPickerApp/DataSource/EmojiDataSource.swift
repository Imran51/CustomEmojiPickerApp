//
//  EmojiDataSource.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import Foundation


enum EmojiCategory: Int, Decodable, CaseIterable {
    case smileysAndPeople
    case animalsAndNature
    case foodAndDrink
    case activity
    case travelAndPlaces
    case objects
    case symbols
    case flags
    case preview
    case search
    
    var stringValue: String {
        switch self {
        case .smileysAndPeople:
            return "Smileys & People"
        case .animalsAndNature:
            return "Animals & Nature"
        case .foodAndDrink:
            return "Food & Drink"
        case .activity:
            return "Activity"
        case .travelAndPlaces:
            return "Travel & Places"
        case .objects:
            return "Objects"
        case .symbols:
            return "Symbols"
        case .flags:
            return "Flags"
        case .preview:
            return ""
        case .search:
            return "Search Results"
        }
    }
    
    var imageName: String {
        switch self {
        case .smileysAndPeople:
            return "face.smiling.inverse"
        case .animalsAndNature:
            return "pawprint.fill"
        case .foodAndDrink:
            return "cup.and.saucer.fill"
        case .activity:
            return "soccerball"
        case .travelAndPlaces:
            return "car.fill"
        case .objects:
            return "lightbulb.fill"
        case .symbols:
            return "number.square.fill"
        case .flags:
            return "flag.fill"
        case .preview:
            return ""
        case .search:
            return ""
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case EmojiCategory.smileysAndPeople.stringValue:
            self = .smileysAndPeople
        case EmojiCategory.animalsAndNature.stringValue:
            self = .animalsAndNature
        case EmojiCategory.foodAndDrink.stringValue:
            self = .foodAndDrink
        case EmojiCategory.activity.stringValue:
            self = .activity
        case EmojiCategory.travelAndPlaces.stringValue:
            self = .travelAndPlaces
        case EmojiCategory.objects.stringValue:
            self = .objects
        case EmojiCategory.symbols.stringValue:
            self = .symbols
        case EmojiCategory.flags.stringValue:
            self = .flags
        default:
            self = .preview
        }
    }
}


protocol EmojiDataSource {
    var items: [EmojiCategorySection] { get }
    
    func getAllCategories() -> [EmojiCategory]
    
    func activateSearch(for text: String)
}

class FullSetOfEmojiDataSource: EmojiDataSource {
    
    private var filterActive = false
    private var originalItems: [EmojiCategorySection] = []
    private var filteredList: [EmojiCategorySection] = []
    
    var items: [EmojiCategorySection] {
        filterActive ? filteredList : originalItems
    }
    
    
    init() {
        originalItems = getPreparedItems()
    }
    
    private func getPreparedItems() -> [EmojiCategorySection] {
        guard let emojiJSONURL = Bundle.main.url(forResource: "Emoji Unicode", withExtension: "json"), let emojiData = try? Data(contentsOf: emojiJSONURL) else {
            return []
        }
        guard let emojis = try? JSONDecoder().decode([Emoji].self, from: emojiData) else {
            return []
        }
        var emojiCategoryMap: [EmojiCategory: [Emoji]] = [:]
        emojis.forEach {
            emojiCategoryMap[$0.category, default: []].append($0)
        }
        let emojisCategorySection = emojiCategoryMap.compactMap{ (category, emojis) in
            EmojiCategorySection(category: category, emojis: emojis)
        }.sorted(by: { $0.category.rawValue < $1.category.rawValue })
        
        return emojisCategorySection
    }
    
    func activateSearch(for text: String) {
        guard !text.isEmpty else {
            filteredList.removeAll()
            filterActive = false
            return
        }
        filterActive = true
        let filterEmojis = originalItems
            .map{
                let emojis = $0.emojis.filter({
                    $0.name.localizedCaseInsensitiveContains(text)
                    || $0.value == text
                    || $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(text) })
                    || $0.aliases.contains(where: { $0.localizedCaseInsensitiveContains(text) })
                })
                return emojis
            }
            .flatMap{ $0 }
        filteredList = [EmojiCategorySection(category: .search, emojis: filterEmojis)]
    }
    
    func getAllCategories() -> [EmojiCategory] {
        originalItems.compactMap { $0.category }
    }
}
