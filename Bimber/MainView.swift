//
//  MainView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/25/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                TrendingPageView()
            }.tabItem {
                Image(systemName: "star.fill")
                Text("Trending")
            }
            NavigationView {
                CategoriesPageView()
            }.tabItem {
                Image(systemName: "folder.fill")
                Text("Categories")
            }
            NavigationView {
                SearchPageView()
            }.tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
}

#Preview {
    MainView()
}
