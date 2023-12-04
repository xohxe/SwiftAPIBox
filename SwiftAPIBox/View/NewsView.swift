//
//  NewsView.swift
//  SwiftNewsAPITest
//
//  Created by 김소혜 on 11/30/23.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject var network = NewsAPI.shared
    var body: some View {
        NavigationStack{
            List{
                ForEach(network.posts, id: \.self) { post in
                    
                    HStack{
                        AsyncImage(url: URL(string: post.urlToImage ?? "" )){ image in
                            image.image?.resizable()
                        }.frame(width: 120,height: 80)
                        Text(post.title)
                            .bold()
                    }.padding(5)
                }
            }.navigationTitle("News")
        }
        .onAppear() {
            network.fetchData()
        }
        
    }
}

//#Preview {
//    NewsView()
//}
