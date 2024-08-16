//
//  ContentView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrendingPageView: View {
    @ObservedObject var controller = TrandingGifsController()
    
    init(controller: TrandingGifsController = TrandingGifsController()) {
        self.controller = controller
        controller.fetchGifs()
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(controller.gifs.indices, id: \.self) { index in
                    createGridItem(gif: controller.gifs[index], index: index)
                }
            }
            .padding()
        }.navigationTitle("Trending")
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
                        controller.fetchGifs(loadMore: true)
                    }
                }
        }
    }
}

//#Preview {
//    TrendingPageView()
//}
