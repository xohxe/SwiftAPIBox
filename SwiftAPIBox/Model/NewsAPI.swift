//
//  NewsAPI.swift
//  SwiftNewsAPITest
//
//  Created by 김소혜 on 11/30/23.
//

import SwiftUI


struct Results : Decodable{
    let articles: [Article]
}
//hasable 구별될수잇게
struct Article : Decodable, Hashable {
    let title : String
    let url : String
    let urlToImage : String?
}
// 구조체 x, 클래스로!
class NewsAPI : ObservableObject {
    
    static let shared = NewsAPI()
    private init(){ }
    
    @Published var posts = [Article]()
    
    
    private var apiKey: String? {
        get {
            let keyfilename = "API_KEY_LIST"
            let api_key = "NEWS_API_KEY"
            // 생성한 .plist 파일경로 불러오기
            guard let filePath = Bundle.main.path(forResource: keyfilename, ofType: "plist") else { fatalError("Couldn't find \(keyfilename).plist") }
            //.plist 파일 내용을 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            // 딕셔너리에서 키 찾기
            guard let value = plist?.object(forKey: api_key) as? String else {
                fatalError("Couldn't find key")
            }
            return value
            
        }
            
    }
    func fetchData(){
        guard let apiKey = apiKey else { return }
        
       // print(apiKey)
        let urlString = "https://newsapi.org/v2/everything?q=Apple&from=2023-11-29&sortBy=popularity&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
         
        // dataTask() 메서드의 with: 매개변수에 url 또는 request 객체를 가지고 통신
        let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
          
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
              // 정상적으로 값이 오지 않았을 때 처리
            self.posts = []
            return
        }
          
        guard let data = data else {
            print("No data received")
            return
        }
            
            
//        let str = String(decoding: data, as: UTF8.self)
//        print(str)
            do {
                // result의 객체가 출력된다.
                let json = try JSONDecoder().decode(Results.self, from: data)
                //print(json)
                DispatchQueue.main.async {
                    self.posts = json.articles
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        
            
            
            
//          do {
//              // func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
//              let json = try JSONDecoder().decode(Results.self, from: data)
//              print(json)
//          } catch let error {
//              print(error.localizedDescription)
//          }
        }
        task.resume()
      


        
    }

}
