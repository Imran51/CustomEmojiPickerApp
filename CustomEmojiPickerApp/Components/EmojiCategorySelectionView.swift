//
//  EmojiCategorySelectionView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import SwiftUI

struct EmojiCategorySelectionView: View {
    let categories: [EmojiCategory]
    let itemSize: CGFloat = 36
    @Binding var selectedCategory: EmojiCategory
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(itemSize))]) {
                ForEach(categories, id: \.self) { category in
                    ZStack {
                        selectedCategory == category ? Color.gray.opacity(0.3) : .clear
                        Image(systemName: category.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(itemSize/4)
                    }
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct EmojiCategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiCategorySelectionView(categories: EmojiCategory.allCases, selectedCategory: .constant(.smileysAndPeople))
    }
}
