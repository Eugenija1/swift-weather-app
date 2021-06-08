
import Foundation
import CoreLocation

struct WeatherModel {
    var records: Array<WeatherRecord> = []
    
    init(cities: Array<(String, String)>) {
        records = Array<WeatherRecord>()
        
        for (city, id) in cities {
            records.append(WeatherRecord(cityName: city, woeId: id))
        }
    }
    
    class WeatherRecord: Identifiable, ObservableObject {
        var woeId: String
        var cityName: String
        @Published var latLong: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        @Published var weatherState: String = ["Snow", "Sleet", "Hail", "Thunderstorm",
                                    "Heavy Rain", "Light Rain", "Heavy Cloud", "Light Cloud", "Clear" ]
            .randomElement()!
        @Published var temperature: Float = Float.random(in: -10.0 ... 30.0)
        @Published var humidity: Float = Float.random(in: 20.0  ... 60.0)
        @Published var windSpeed: Float = Float.random(in: 0 ... 20)
        @Published var windDirection: String = "NW"
        
        init(cityName: String, woeId: String) {
            self.cityName = cityName
            self.woeId = woeId
        }
        
        func update(temperature: Float, humidity: Float, windSpeed: Float, windDirection: String, weatherState: String){
            self.weatherState = weatherState
            self.temperature = temperature
            self.humidity = humidity
            self.windSpeed = windSpeed
            self.windDirection = windDirection
        }
        
        func setLatLong(latitude: Float, longitude: Float){
            self.latLong = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
    }
    
    mutating func refresh(record: WeatherRecord){
        let index = records.firstIndex(where: {$0.id == record.id})
        records[index!].temperature = Float.random(in: -10 ... 30.0)
        print("Refresing record: \(record)")
    }
}
