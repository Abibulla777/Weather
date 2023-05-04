//
//  WeatherModel.swift
//  Weather
//
//  Created by abibulla on 27.04.2023.
//

import Foundation

class WeatherModel: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    class Main: Decodable {
        let temp: Double
        let pressure: Double
        let humidity: Double
    }
    
    class Weather: Decodable {
        let id: Int
    }
    class Wind: Decodable {
        let gust: Double
        let speed: Double
    }
}
