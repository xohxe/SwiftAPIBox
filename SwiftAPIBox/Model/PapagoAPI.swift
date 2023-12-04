//
//  PapagoAPI.swift
//  SwiftAPIBox
//
//  Created by 김소혜 on 12/1/23.
//

 
import SwiftUI

struct TranslateResults: Decodable {
    let message : Message
}

struct Message : Decodable {
    let type: String
    let service : String
    let version : String
    let result : Result
    
    enum CodingKeys : String, CodingKey {
        case result
        case type = "@type"
        case service = "@service"
        case version = "@version"
    }
}


struct Result :Decodable {
    let translatedText : String
}



class PapagoAPI : ObservableObject {
    
    static let shared = PapagoAPI()
    private init(){ }
    
    @Published var targetString : String?
    
    private var clientID : String?{
        get {getValueOfPlistFile("API_KEY_LIST", "PAPAGO_CLIENT_ID")}
    }
    
    private var clientSecret : String?{
        get {getValueOfPlistFile("API_KEY_LIST", "PAPAGO_CLIENT_SECRET")}
    }
   
    func fetchData(_ sourceString: String){
        guard let clientID = clientID else {return}
        guard let clientSecret = clientSecret else {return}
        
        let urlString = "https://openapi.naver.com/v1/papago/n2mt"
        
        guard let url = URL(string: urlString ) else { return }
        
        let session = URLSession(configuration: .default)
        
        //let sourceString = "좋은 주말되세요"
        let strWithParameters = "source=ko&target=en&text=\(sourceString)"
        let data = strWithParameters.data(using: .utf8)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpBody = data
        
        // dataTask() 메서드의 with: 매개변수에 url 또는 request 객체를 가지고 통신
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
   
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // 정상적으로 값이 오지 않았을 때 처리
                //self.posts = []
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
    
//            let str = String(decoding: data, as: UTF8.self)
//           print(str)
            
            do{
                let results = try JSONDecoder().decode(TranslateResults.self, from: data)
                DispatchQueue.main.async {
                    self.targetString = results.message.result.translatedText
                }
            } catch let error {
                print(error.localizedDescription)
            }
        
        
            
 
        }
        task.resume()
 
    }
}
