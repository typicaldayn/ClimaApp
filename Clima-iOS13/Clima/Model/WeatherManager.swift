//
//  WeatherManager.swift
//  Clima
//
//  Created by Stas Bezhan on 13.06.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}
    
struct WeatherManager {

    var delegate: WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?"
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)lat=\(latitude)&lon=\(longitude)&appid=37b2a228174b8ec01be54ec2f24ad300&units=metric&"
        performRequest(urlString: urlString)
    }
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)q=\(cityName)&appid=37b2a228174b8ec01be54ec2f24ad300&units=metric&"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            task.resume()
        }
    }

        func parseJSON(weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                return weather
            }catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
}
