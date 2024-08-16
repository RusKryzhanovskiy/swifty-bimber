//
//  ContentView.swift
//  Bimber
//
//  Created by Ruslan Kryzhanovskyi on 2/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoriesPageView: View {
    @ObservedObject var controller = CategoriesController()
    
    init(controller: CategoriesController = CategoriesController()) {
        self.controller = controller
        controller.fetchCategories()
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(controller.categories, id: \.name) { category in
                    NavigationLink(destination: SearchResultPageView(query: category.name!),label: {
                        ZStack{
                            AnimatedImage(url:URL(string: category.gif.images!.original!.url!))
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 14.0))
                            if let categoryName = category.name {
                                VStack {
                                    Spacer()
                                    Text(categoryName)
                                        .frame(maxWidth: .infinity)
                                        .padding(4)
                                        .background(BlurView(style: .systemUltraThinMaterial)) // Custom BlurView
                                        .clipShape(BottomRoundedRectangle(cornerRadius: 14.0))
                                        .foregroundColor(Color.primary)
                                }
                            }
                        }
                    })
                }
            }
            .padding()
        }.navigationTitle("Categories")
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height - cornerRadius))
        path.closeSubpath()
        return path
    }
}

//#Preview {
//    CategoriesPageView()
//}
