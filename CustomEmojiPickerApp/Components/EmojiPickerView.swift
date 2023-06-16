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
    
    private let dataSource: EmojiDataSource = FullSetOfEmojiDataSource()
    
    @State var searchText: String = ""
    @State var selectedEmojiSection: EmojiCategory = .smileysAndPeople
    @State var isSearchActive = false
    
    var searchResults: [EmojiCategorySection] {
        dataSource.activateSearch(for: searchText)
        return dataSource.items
    }
    
    private let innerColumns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    private let outerColumns = [
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        VStack {
            // MARK: - Search Bar
            SearchbarView(searchText: $searchText, isSearching: $isSearchActive)
                .padding()
            
            ScrollViewReader { proxy in
                // MARK: - ScrollView
                ScrollView {
                    LazyVGrid(columns: outerColumns) {
                        // MARK: - Outer Loop for section implementation
                        ForEach(searchResults, id: \.category) { result in
                            VStack(alignment: .leading) {
                                Text(result.category.stringValue)
                                    .font(.title2)
                                    .padding(.horizontal, 15)
                                // MARK: - Inner loop for emoji cell display
                                LazyVGrid(columns: innerColumns) {
                                    ForEach(result.emojis, id: \.id) { emoji in
                                        Text(emoji.value)
                                            .font(.largeTitle)
                                            .onTapGesture {
                                                print(emoji.name)
                                                dismiss()
                                            }
                                    }
                                }
                                .padding(.horizontal, 10)
                                // MARK: - inner LazyVGrid with loop
                            }
                            .padding(.vertical, 10)
                            .onAppear {
                                guard result.category != selectedEmojiSection else { return }
                                withAnimation {
                                    selectedEmojiSection = result.category
                                }
                            }
                            // MARK: - outer VStack Ends here
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
               
                // MARK: - ScrollView End
                
                // MARK: - Category view
                if !isSearchActive {
                    EmojiCategorySelectionView(categories: EmojiCategory.allCases, selectedCategory: $selectedEmojiSection, scrollProxy: proxy)
                        .frame(height: 60)
                        .padding(.horizontal)
                    
                }
            }
        }
        .padding(.top)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isSearchActive = false
    }
}

struct EmojiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView()
    }
}
