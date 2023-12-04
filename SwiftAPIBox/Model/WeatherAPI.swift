//
//  WeatherAPI.swift
//  SwiftNewsAPITest
//
//  Created by 김소혜 on 11/30/23.
//

import SwiftUI
import Foundation
 
// MARK: - 현재 날씨 데이터
struct WeatherData: Codable{
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
  //  let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - 예보 데이터
struct ForecastData : Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
    let city: City
}


// MARK: - List
struct ForecastList: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
   // let visibility: Int
    //let pop: Double
    //let sys: Sys
    let dtTxt: String
  // let rain: [Rain]?

    enum CodingKeys: String, CodingKey {
        case dt, main, clouds, wind, weather
      //  case dt, weather, clouds, wind, rain
        case dtTxt = "dt_txt"
      
    }
}


// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}


// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
  //  let pressure, humidity, seaLevel, grndLevel: Int
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
       // case pressure, humidity
       // case seaLevel = "sea_level"
       // case grndLevel = "grnd_level"
      case tempKf = "temp_kf"
    }
}
 
// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}
 

class WeatherAPI : ObservableObject {
    static let shared  = WeatherAPI()
    private init(){}
    
    @Published var datas = [WeatherData]()
    @Published var datasF = [ForecastData]()
    
    private var apiKey : String?{
        get {getValueOfPlistFile("API_KEY_LIST", "WEATHER_API_KEY")}
    }
   
    func fetchDataAll(){
        fetchData("weather")
        fetchData("forecast")
    }
    
    func fetchData(_ fetchStr: String){
        
        guard let apiKey = apiKey else { return }
       //print(apiKey)
        
        let currentLat : Double = 35.554134
        let currentLon : Double = 126.93709
        
        // 현재 날씨
        let urlString = "https://api.openweathermap.org/data/2.5/\(fetchStr)?lat=\(currentLat)&lon=\(currentLon)&appid=\(apiKey)&lang=kr&units=metric"
        
      //  print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
          
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
              
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                //self.datas = []
                return
            }
              
            guard let data = data else {
                print("No data received")
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            
            do {
                if fetchStr == "weather" {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                   print(weatherData)
                   DispatchQueue.main.async {
                       self.datas = [weatherData]
                       // UI 업데이트
                   }
               } else if fetchStr == "forecast" {
                   let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
                   print(forecastData)
                   DispatchQueue.main.async {
                       self.datasF = [forecastData]
                       // UI 업데이트
                   }
               }

            } catch let error {
                print(error.localizedDescription)
                
            }
            
        }
        
        
        task.resume()
      


        
    }
     
}
