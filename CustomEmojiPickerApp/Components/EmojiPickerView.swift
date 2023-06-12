//
//  EmojiPickerView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import SwiftUI

struct EmojiPickerView: View {
    let dataSource: EmojiDataSource = FullSetOfEmojiDataSource()
    @State var searchText: String = ""
    
    var searchResults: [EmojiCategorySection] {
        dataSource.activateSearch(for: searchText)
        return dataSource.items
    }
    
    let innerColumns = [
        GridItem(.adaptive(minimum: 40))
    ]
    
    let outerColumns = [
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: outerColumns) {
                    ForEach(searchResults, id: \.category) { result in
                        VStack(alignment: .leading) {
                            Text(result.category.stringValue)
                                .font(.title2)
                                .padding(.horizontal, 15)
                            LazyVGrid(columns: innerColumns) {
                                ForEach(result.emojis, id: \.id) { emoji in
                                    Text(emoji.value)
                                        .font(.title)
                                }
                            }
                            .padding(.horizontal, 10)
                            
                        }
                        .padding(.vertical, 10)
                        .onAppear{
                            print(result.category)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
        }
        .padding(.top)
    }
}

struct EmojiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView()
    }
}
