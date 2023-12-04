//
//  TabBarView.swift
//  SwiftNewsAPITest
//
//  Created by 김소혜 on 11/30/23.
//

import SwiftUI

struct TabBarView: View {
    // 처음 화면에서만 로드 되게 해야함. 나중에 이부분만 true로 변경
    @State private var showingPopover = false
    @State public var tabViewSelection = 0
    
 
    var body: some View {
        NavigationView{
            TabView(selection: $tabViewSelection){
                NavigationView{
                   NewsView()
                }.tag(0)
                .tabItem {
                    Image(systemName: "newspaper")
                        .resizable()
                    Text("뉴스")
                }
                
                NavigationView{
                     WeatherView()
                }.tag(1)
                .tabItem {
                    Image(systemName: "cloud.rainbow.half")
                        .resizable()
                    Text("날씨")
                }
  
                NavigationView{
                    PapagoView()
                }.tag(1)
                .tabItem {
                    Image(systemName: "globe")
                        .resizable()
                    Text("번역")
                }
            }
        }
    }
}
    
 
 
