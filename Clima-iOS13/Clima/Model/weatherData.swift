//
//  weatherData.swift
//  Clima
//
//  Created by Stas Bezhan on 13.06.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
