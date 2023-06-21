//
//  EmojiPickerView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import SwiftUI
import Combine

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    private let dataSource: EmojiDataSource
    
    @State private var searchText: String = ""
    @State private var selectedEmojiSection: EmojiCategory = .smileysAndPeople
    @State private var isSearchActive = false
    private let categories: [EmojiCategory]
    
    init() {
       dataSource = FullSetOfEmojiDataSource()
       categories = dataSource.getAllCategories()
    }
    
    var searchResults: [EmojiCategorySection] {
        dataSource.activateSearch(for: searchText)
        return dataSource.items
    }
    
    private let innerColumns = [
        GridItem(.adaptive(minimum: 30))
    ]
    
    private let outerColumns = [
        GridItem(.flexible(minimum: 30))
    ]
    
    var body: some View {
        VStack {
            // MARK: - Search Bar
            SearchbarView(searchText: $searchText, isSearching: $isSearchActive)
                .padding()
                .onChange(of: isSearchActive) { newValue in
                    guard !newValue else { return }
                    hideKeyboard()
                }
            
            // MARK: - ScrollView
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVGrid(columns: outerColumns, alignment: .leading) {
                        // MARK: - Outer Loop for section implementation
                        ForEach(searchResults, id: \.category.rawValue) { result in
                            Text(result.category.stringValue)
                                .font(.title3)
                                .padding(.horizontal, 15)
                            // MARK: - Inner loop for emoji cell display
                            LazyVGrid(columns: innerColumns, spacing: 4) {
                                ForEach(result.emojis, id: \.id) { emoji in
                                    Text(emoji.value)
                                        .font(.title3)
                                        .onTapGesture {
                                            dismiss()
                                        }
                                }
                            }
                            .padding(.horizontal, 10)
                            // MARK: - outer VStack Ends here
                        }
                    }
                }
                .padding(.horizontal)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged({ _ in
                            isSearchActive = false
                        })
                )
                .onChange(of: selectedEmojiSection) { newValue in
                    proxy.scrollTo(newValue.rawValue, anchor: .top)
                }
            } // MARK: - ScrollView End
            
            // MARK: - Category view
            if !isSearchActive && searchText.isEmpty {
                EmojiCategorySelectionView(categories: categories, selectedCategory: $selectedEmojiSection)
                    .frame(height: 60)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EmojiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView()
    }
}
