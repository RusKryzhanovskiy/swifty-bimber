//
//  ContentView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchResultPageView: View {
    @ObservedObject var controller = SearchResultController()
    var query: String
    
    init(query: String, controller: SearchResultController = SearchResultController()) {
        self.controller = controller
        self.query = query
        controller.fetchGifs(query: query)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(controller.gifs.indices, id: \.self) { index in
                    createGridItem(gif: controller.gifs[index], index: index)
                }
            }
            .padding()
            .navigationTitle(query)
        }
    }
    
    @ViewBuilder
        private func createGridItem(gif: GifModel, index: Int) -> some View {
            NavigationLink(destination: GifDetailsView(gif: gif)) {
                AnimatedImage(url: URL(string: gif.images!.original!.url!))
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0))
                    .onAppear {
                        if index == controller.gifs.count - 1 {
                            controller.fetchGifs(query: query)
                        }
                    }
            }
        }
}

//#Preview {
//    SearchResultPageView(query: "Example")
//}
