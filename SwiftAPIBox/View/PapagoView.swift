//
//  PapagoView.swift
//  SwiftAPIBox
//
//  Created by 김소혜 on 12/1/23.
//

import SwiftUI

struct PapagoView : View {
    @StateObject var network = PapagoAPI.shared
    @State var sourceString = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                
                    Text("결과")
                    Text(network.targetString ?? "")
                }
                
                TextField("입력하세요..", text: $sourceString)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                Button("번역") {
                    network.fetchData( sourceString )
                }
                  
            }.padding()
        }
         
    }
}
