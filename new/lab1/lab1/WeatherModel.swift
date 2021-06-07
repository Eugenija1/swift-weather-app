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
    
    init(cities: Dictionary<String, String>){
        records = Array<WeatherRecord>()
        for (woeid, name) in cities {
            let weatherStateCode = weather_states.keys.randomElement()!
            let weatherSt = weather_states[weatherStateCode]!
            let weatherIcon = weather_icons[weatherStateCode]!
            records.append(WeatherRecord(woeId: woeid, cityName: name, icon: weatherIcon, weatherState: weatherSt))
        }
    }
    
    struct WeatherRecord: Identifiable {
        var id: UUID = UUID()
        var woeId: String
        var cityName: String
        var long: Double = 1.0
        var latt: Double = 1.0
        var icon: String = "☀️"
        var weatherState: String = "clear"
        var temperature: Double = Double.random(in: 0 ... 30)
        var humidity: Int = Int.random(in: 0 ... 100)
        var windSpeed: Double = Double.random(in: 0 ... 20)
        var windDirection: Double = Double.random(in: 0 ..< 360)
    }
    
    mutating func refresh(record: WeatherRecord){
        var index: Int = -1
        for (ind,rec) in records.enumerated(){
            if rec.cityName == record.cityName{
                index = ind
            }
            
        }
        records[index].temperature = Double.random(in: -10.0 ... 30.0)
        print("refreshing record: \(records[index])")
    }
    
    mutating func refresh2(woeId: String, response:MetaWeatherRepsonse){
        var index: Int = -1
        for (ind,rec) in records.enumerated(){
            if rec.woeId == woeId{
                index = ind
            }
        }
        print("index: \(index)")
        records[index].latt = Double(response.lattLong.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces))!
        print(response.lattLong.components(separatedBy: ","))
        records[index].long = Double(response.lattLong.components(separatedBy: ",")[1].trimmingCharacters(in: .whitespaces))!
        records[index].weatherState = response.consolidatedWeather[0].weatherStateAbbr
        records[index].temperature = response.consolidatedWeather[0].theTemp
        records[index].humidity = response.consolidatedWeather[0].humidity
        records[index].windSpeed = response.consolidatedWeather[0].windSpeed
        records[index].windDirection = response.consolidatedWeather[0].windDirection
        print("refresh2 of record: \(records[index])")
    }
}
