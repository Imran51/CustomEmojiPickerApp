//
//  ContentView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var displayEmojiPicker: Bool = false
    @State var selectedEmojis: [Emoji] = []
    let emojiDataSource: EmojiDataSource
    
    init() {
        emojiDataSource = FullSetOfEmojiDataSource()
    }
    
    var body: some View {
        ZStack {
            Color.mint
            VStack(spacing: 20) {
                Text(selectedEmojis.isEmpty ? "Pick a emoji" : selectedEmojis.compactMap{ $0.value }.joined(separator: ","))
                    .font(.largeTitle)
                Button("Single Emoji Selection") {
                    displayEmojiPicker.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                .sheet(isPresented: $displayEmojiPicker) {
                    EmojiPickerView(dataSource: emojiDataSource,selectedEmojis: $selectedEmojis)
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
