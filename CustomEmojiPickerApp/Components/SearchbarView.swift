//
//  SearchbarView.swift
//  CustomEmojiPickerApp
//
//  Created by Imran Sayeed on 6/15/23.
//

import SwiftUI

struct SearchbarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        TextField("Search", text: $searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
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
                            hideKeyboard()
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }.padding()
            }
            .onTapGesture {
                isSearching = true
            }
    }
    
    private func hideKeyboard() {
        searchText = ""
        isSearching = false
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView(searchText: .constant(""), isSearching: .constant(false))
    }
}
