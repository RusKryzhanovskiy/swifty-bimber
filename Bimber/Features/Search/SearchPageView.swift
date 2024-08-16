//
//  SearchPageView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchPageView: View {
    @ObservedObject var controller = SearchController()
    
    init(controller: SearchController = SearchController()) {
        self.controller = controller
    }
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("Type your request...", text: $controller.query)
                    .padding(8)
                    .padding(.horizontal, 24)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            if !self.controller.query.isEmpty {
                                Button(action: {
                                    self.controller.query = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                if !self.controller.query.isEmpty {
                    NavigationLink(destination: SearchResultPageView(query: self.controller.query).onSubmit {
                        self.controller.query = ""
                    }){
                        Text("Let's go!")
                    }.padding(.trailing, 20)
                }
            }.padding(8)
            ForEach(controller.autocomplete, id: \.name) { autocomplete in
                if autocomplete.name != nil {
                    NavigationLink(destination: SearchResultPageView(query: autocomplete.name!)){
                        Text(autocomplete.name!)
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}

//#Preview {
//    NavigationView {
//        SearchPageView()
//    }
//}
