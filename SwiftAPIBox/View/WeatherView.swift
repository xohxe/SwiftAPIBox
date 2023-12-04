//
//  WeatherView.swift
//  SwiftNewsAPITest
//
//  Created by 김소혜 on 11/30/23.
//

import SwiftUI
import MapKit
 

struct WeatherView : View {
    
    @StateObject var network = WeatherAPI.shared
//    
//    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
//           center: CLLocationCoordinate2D(latitude: 37.566691, longitude: 126.978365),
//           span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//       ))
    
    
    var body: some View {
     
        ZStack{
          
           // Map(position: $cameraPosition).opacity(0.8)
                
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack{
                
                Text("나의 위치")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
//                    .background(Color.blue)
//                    .cornerRadius(10)
                
                Text(network.datas.first?.name ?? " ")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.white)
                // 현재날씨
                Text("\(String(format: "%.1f", network.datas.first?.main.temp ?? 0 ))°")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                Text(network.datas.first?.weather.first?.main ?? "..")
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                Text("최고: \(String(format: "%.1f", network.datas.first?.main.tempMax ?? 0 ))°, 최저: \(String(format: "%.1f", network.datas.first?.main.tempMin ?? 0 ))°")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                //Text(network.datas.map { $0.name }.joined(separator: ", "))
                
                //Text("오후 10시~오후11시에 부분적으로 흐린 상태가, 오후 11시에 청명한 상태가 예상됩니다.")
                
                HStack{
                    ForEach(0..<10) { index in
                        VStack{
                            Text("\(index)")
                            Image(systemName: "cloud.fill")
                            Text("\(String(format: "%.1f", network.datasF.first?.list[index].main.temp ?? 0 ))°")
    
                        }
                    }

                   
                    
                }
            }

             
        }
        .onAppear() {
            network.fetchDataAll()
            
            
        }
    }
}
//#Preview {
//    WeatherView(network: )
//}

//struct MapViewCoordinator : UIViewRepresentable {
//    @ObservedObject var locationManager : LocationManager
//    
//    func makeUIView(context: Context) -> some UIView {
//        return locationManager.mapView
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context : Context){
//        
//    }
//}
