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
    
    mutating func refresh2(woeId: String, response:MetaWeatherRepsonse, currentLocation: String, currentName: String, currentCoor: String){
        var index: Int = -1
        for (ind,rec) in records.enumerated(){
            if rec.woeId == woeId{
                index = ind
                
            }
            
        }
        print("index \(currentCoor)")
        if records[index].cityName == self.currentCityName{
            records[index].latt = Double(currentCoor.components(separatedBy: ",")[0])!
            records[index].long = Double(currentCoor.components(separatedBy: ",")[1])!
        } else{
            records[index].latt = Double(response.lattLong.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces))!
             print(response.lattLong.components(separatedBy: ","))
             records[index].long = Double(response.lattLong.components(separatedBy: ",")[1].trimmingCharacters(in: .whitespaces))!        }

        
        records[index].weatherState = response.consolidatedWeather[0].weatherStateAbbr
        records[index].temperature = response.consolidatedWeather[0].theTemp
        records[index].humidity = response.consolidatedWeather[0].humidity
        records[index].windSpeed = response.consolidatedWeather[0].windSpeed
        records[index].windDirection = response.consolidatedWeather[0].windDirection
        print("refresh2 of record: \(records[index])")
    }
    
    var currentCityName: String = ""
    
    mutating func refreshLoc(currentCity: String, currentCoord: String, response: NearestLocationResponse){
        var index: Int = -1
        for (ind,rec) in records.enumerated(){
            if rec.woeId == "0"{
                records[ind].cityName = records[0].cityName
                records[ind].latt = records[0].latt
                records[ind].long = records[0].long
                records[ind].woeId = records[0].woeId
                
                print("location that was on 0: \(ind)")
                self.currentCityName = currentCity
                self.currentCityName += " ("
                self.currentCityName += response[0].title
                self.currentCityName += ")"
                print("location near: \(self.currentCityName)")
                print("current coord \(currentCoord)")
                records[0].cityName = self.currentCityName
                records[0].latt = Double(currentCoord.components(separatedBy: ",")[0])!
                records[0].long = Double(currentCoord.components(separatedBy: ",")[1])!
                records[0].woeId = String(response[0].woeid)            }
        }
    }
}
