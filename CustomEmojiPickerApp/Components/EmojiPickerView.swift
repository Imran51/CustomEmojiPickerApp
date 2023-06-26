//
//  EmojiPickerView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/12/23.
//

import SwiftUI
import Combine

class PublishableCategory: ObservableObject {
    @Published var category: EmojiCategory = .preview
}

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var pickedCategory = PublishableCategory()
    
    @Binding var selectedEmojis: [Emoji]?
    @State private var clickActivated = false
    @State private var searchText: String = ""
    @State private var selectedEmojiSection: EmojiCategory = .preview
    @State private var isSearchActive = false
    
    let dataSource: EmojiDataSource
    
    private let debouncedCategory = PassthroughSubject<EmojiCategory, Never>()
    
    private var categories: [EmojiCategory] {
        dataSource.getAllCategories()
    }
    
    var searchResults: [EmojiCategorySection] {
        dataSource.activateSearch(for: searchText)
        return dataSource.items
    }
    
    private let innerColumns = [
        GridItem(.adaptive(minimum: 40))
    ]
    
    private let outerColumns = [
        GridItem(.flexible(minimum: 70))
    ]
    
    @State var visibleSection: Set<EmojiCategory> = []
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                // MARK: - Search Bar
                SearchbarView(searchText: $searchText, isSearching: $isSearchActive)
                    .onChange(of: isSearchActive) { newValue in
                        guard !newValue else { return }
                        hideKeyboard()
                    }
                // MARK: - ScrollView
                
                ScrollView {
                    LazyVGrid(columns: outerColumns, alignment: .leading) {
                        // MARK: - Outer Loop for section implementation
                        ForEach(searchResults, id: \.category.rawValue) { result in
                            Text(result.category.stringValue)
                                .font(.title2)
                                .padding(10)
                                .onAppear {
                                    visibleSection.insert(result.category)
                                    debouncedCategory.send(result.category)
                                }
                                .onDisappear {
                                    visibleSection.remove(result.category)
                                }
                            
                            // MARK: - Inner loop for emoji cell display
                            LazyVGrid(columns: innerColumns) {
                                ForEach(result.emojis, id: \.value) { emoji in
                                    Text(emoji.value)
                                        .font(.title)
                                        .onTapGesture {
                                            selectedEmojis?.append(emoji)
                                            dismiss()
                                        }
                                }
                            }
                            // MARK: - outer VStack Ends here
                        }
                    }
                }
                .layoutPriority(.greatestFiniteMagnitude)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged({ _ in
                            isSearchActive = false
                        })
                )
                .onReceive(pickedCategory.objectWillChange) { output in
                    clickActivated.toggle()
                    withAnimation {
                        proxy.scrollTo(pickedCategory.category.rawValue, anchor: .top)
                    }
                }
                // MARK: - ScrollView End
                
                // MARK: - Category view
                if !isSearchActive && searchText.isEmpty {

                    EmojiCategorySelectionView(categories: categories, selectedCategory: $selectedEmojiSection)
                        .frame(height:40)
                        .environmentObject(pickedCategory)
                        .onReceive(debouncedCategory.debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)) { output in
                            guard !clickActivated else { return clickActivated.toggle() }
                            selectedEmojiSection = output
                        }
                }
            }
            .padding()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EmojiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView(selectedEmojis: .constant(nil), dataSource: FullSetOfEmojiDataSource())
    }
}
