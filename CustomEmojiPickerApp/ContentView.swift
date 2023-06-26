//
//  ContentView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var displayEmojiPicker: Bool = false
    @State var selectedEmojis: [Emoji]? = []
    private var showableEmojis: String {
        guard let selectedEmojis, !selectedEmojis.isEmpty else {
            return "Pick a emoji"
        }
        return selectedEmojis.map { $0.value }.joined(separator: ",")
    }
    let emojiDataSource: EmojiDataSource
    
    init() {
        emojiDataSource = FullSetOfEmojiDataSource()
    }
    
    var body: some View {
        ZStack {
            Color.mint
            VStack(spacing: 20) {
                Text(showableEmojis)
                    .font(.largeTitle)
                Button("Single Emoji Selection") {
                    displayEmojiPicker.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                .sheet(isPresented: $displayEmojiPicker) {
                    EmojiPickerView(selectedEmojis: $selectedEmojis, dataSource: emojiDataSource)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.automatic)
                        
                }
                
                
                Button("Multiple Emoji Selection") {
                    // picker
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
