//
//  EmojiPickerView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import SwiftUI

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    let dataSource: EmojiDataSource = FullSetOfEmojiDataSource()
    @State var searchText: String = ""
    
    var searchResults: [EmojiCategorySection] {
        dataSource.activateSearch(for: searchText)
        return dataSource.items
    }
    
    let innerColumns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    let outerColumns = [
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        VStack {
            // MARK: - Search Bar
            SearchbarView(searchText: $searchText)
                .padding()
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
                        .onAppear{
                            print(result.category)
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
            // MARK: - Outer layer LazyVGrid
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
