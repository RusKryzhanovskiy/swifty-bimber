//
//  GifDetailsView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifDetailsView: View {
    let gif:GifModel
    
    init(gif: GifModel) {
        self.gif = gif
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    if let avatarUrl = gif.user?.avatarURL {
                        AsyncImage(url: URL(string: avatarUrl)){ image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                    if let username = gif.username {
                        Text(username)
                    }
                    Spacer()
                    if let rating = gif.rating {
                        Text("Rating: \(rating)")
                    }
                }
                .padding()
                AnimatedImage(url:URL(string:gif.images!.original!.url!))
                    .resizable()
                    .scaledToFit()
                if let title = gif.title {
                    Text(title).padding()
                }
            }
        }
        .navigationTitle("Content")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ShareLink(item: URL(string: gif.embedURL!)!) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}
