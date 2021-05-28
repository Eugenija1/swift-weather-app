//
//  WeatherModel.swift
//  lab1
//
//  Created by AppleLab on 05/05/2021.
//

import Foundation

struct WeatherModel{
    
    var records: Array<WeatherRecord> = []
    var weather_icons = ["sn": "🌨", "t": "🌩", "hr": "🌧", "lr": "🌧", "s": "🌦", "hc": "☁️", "lc": "🌤", "c":"☀️"]
    var weather_states :[String:String] = ["sn": "snow", "t": "thunder", "hr": "heavy rain", "lr": "light rain", "s": "showers", "hc": "heavy cloud", "lc": "light cloud", "c": "clear"]
    
    init(cities: Array<String>){
        records = Array<WeatherRecord>()
        for city in cities {
            let weatherStateCode = weather_states.keys.randomElement()!
            let weatherSt = weather_states[weatherStateCode]!
            let weatherIcon = weather_icons[weatherStateCode]!
            records.append(WeatherRecord(cityName: city, icon: weatherIcon, weatherState: weatherSt))
        }
    }
    
    struct WeatherRecord: Identifiable {
        var id: UUID = UUID()
        var cityName: String
        var icon: String
        var weatherState: String
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
    }
    
    mutating func refresh(record: WeatherRecord){
        var index: Int = -1
        for (ind,rec) in records.enumerated(){
            if rec.cityName == record.cityName{
                index = ind
            }
            
        }
        records[index].temperature = Float.random(in: -10.0 ... 30.0)
        print("refreshing record: \(records[index])")
    }
}
