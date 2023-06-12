//
//  ContentView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var displayEmojiPicker: Bool = false
    
    var body: some View {
        ZStack {
            Color.mint
            VStack(spacing: 20) {
                Text("Picked Image content will be displayed here")
                    .font(.headline)
                Button("Single Emoji Selection") {
                    // picker navigation
                }
                .buttonStyle(.borderedProminent)
                
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
