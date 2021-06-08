
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published private(set) var model: WeatherModel = WeatherModel(cities: [("London",  "44418"), ("Paris", "615702"), ("Berlin", "638242"), ("Madrid", "766273"), ("Rome", "721943"), ("Warsaw", "523920"), ("Oslo", "862592"), ("Kyiv", "924938"), ("Moscow", "2122265")])
    
    @Published var woeId: String = ""
    @Published var message: String = "(user message)"
        
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetcher: MetaWeatherFetcher
    
    private var fetchedTemp: Float = 0.0
    private var fetchedHumidity: Float = 0.0
    private var fetchedWindSpeed: Float = 0.0
    private var fetchedWindDirection: String = ""
    private var fetchedWeatherState: String = ""
    var fetchedLatlong: String = "0.0,0.0"
    
    init() {
        fetcher = MetaWeatherFetcher()
        for weatherRecord in model.records {
            refresh(record: weatherRecord)
        }
    }
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord) {
        fetchWeather(forId: record.woeId)
    }
    
    func fetchWeather(forId woeId: String) {
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.fetchedTemp = value.consolidatedWeather[0].theTemp
                self.fetchedHumidity = value.consolidatedWeather[0].humidity
                self.fetchedWindSpeed = value.consolidatedWeather[0].windSpeed
                self.fetchedWindDirection = value.consolidatedWeather[0].windDirectionCompass
                self.fetchedWeatherState = value.consolidatedWeather[0].weatherStateName
                self.fetchedLatlong = value.lattLong
                let index = self.records.firstIndex(where: {$0.woeId == woeId})
                let flatitude = Float(self.fetchedLatlong.components(separatedBy: ",")[0])!
                let flongitude = Float(self.fetchedLatlong.components(separatedBy: ",")[1])!
                self.records[index!].setLatLong(latitude: flatitude, longitude: flongitude)
                self.records[index!].update(temperature: self.fetchedTemp, humidity: self.fetchedHumidity, windSpeed: self.fetchedWindSpeed, windDirection: self.fetchedWindDirection, weatherState: self.fetchedWeatherState)            })
            
        
            .store(in: &cancellables)
    }
}
