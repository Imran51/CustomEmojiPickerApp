//
//  SearchbarView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/15/23.
//

import SwiftUI
import Combine

struct SearchbarView: View {
    @Binding var searchText: String
    @State private var debounceSearchText: String = ""
    @Binding var isSearching: Bool
    private let searchTextPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        TextField("Search", text: $debounceSearchText, onCommit: {
            isSearching = false
        })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    Spacer()
                    if isSearching {
                        Button(action: {
                            searchText = ""
                            isSearching = false
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }.padding()
            }
            .onChange(of: debounceSearchText, perform: { newValue in
                searchTextPublisher.send(newValue)
            })
            .onReceive(searchTextPublisher.debounce(for: .milliseconds(200), scheduler: RunLoop.main), perform: { output in
                searchText = output
            })
            .onTapGesture {
                isSearching = true
            }
    }
}

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView(searchText: .constant(""), isSearching: .constant(false))
    }
}
