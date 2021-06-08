//
//  WeatherViewModel.swift
//  lab1
//
//  Created by AppleLab on 05/05/2021.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private var model: WeatherModel = WeatherModel(cities: ["0": "Current Location", "2459115": "New York", "2442047": "Los Angeles", "4118": "Toronto", "2295019": "New Delhi", "1105779": "Sydney", "44418": "London", "638243": "Berlin", "766273": "Madrid", "721943": "Rome", "615702": "Paris"])
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    private var cancellables: Set<AnyCancellable> = []
    private var cancellables2: Set<AnyCancellable> = []
    private var fetcher: MetaWeatherFeatcher
    private var locationSearcher: SearchNearestLocation
    private let locationManager: CLLocationManager
    @Published var nearestWoeid : String = "0"
    @Published var currentLocation: CLLocation?
    @Published var currentLocName: String = "City Name"
    
    func fetchWeather(forId woeid: String){
            fetcher.forecast(forId: woeid)
                .sink(receiveCompletion: {completion in
                    print(completion)
                }, receiveValue: { value in
                    //print(value)
                    
                    self.model.refresh2(woeId: woeid, response: value, currentLocation: self.nearestWoeid, currentName: self.currentLocName)
                })
                .store(in: &cancellables)
    }
    
    func fetchNearestLocation(forId coordinates: String){
        locationSearcher.forecast(forId: coordinates)
            .sink(receiveCompletion: {completion in print(completion)},
                  receiveValue: {value in //self.appendFirstWoeid(response: value)
                    self.model.refreshLoc(currentCity: self.currentLocName, response: value)
                    self.nearestWoeid = String(value[0].woeid)
                    self.fetchWeather(forId:self.nearestWoeid)
                    print("recieved nearest loc: \(value)")
                  })
            .store(in: &cancellables2)
    }
    

    
    override init(){
        locationManager = CLLocationManager()
        fetcher = MetaWeatherFeatcher()
        locationSearcher = SearchNearestLocation()
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    
        
        
        for record in records{
                refresh(record: record)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.first
        let geocoder = CLGeocoder()
        if let location = currentLocation{
            geocoder.reverseGeocodeLocation(location){ [self]
                placemarks, error in
                self.currentLocName = placemarks![0].locality!
                
                print("current location \(String(describing: self.currentLocName))")
                if self.currentLocName != "City Name"{
                    refreshCurrentLoc()
                }
            }
            
        }
       
        print("current loc 2 \(String(self.currentLocName))")
        
        
    }
    
    
    func refresh(record: WeatherModel.WeatherRecord){
        fetchWeather(forId: record.woeId)
        //model.refresh(record: record)
    }

    func refreshCurrentLoc() {
        var str = String(currentLocation?.coordinate.latitude ?? 50.0)
        str += ","
        str += String(currentLocation?.coordinate.longitude ?? 20.0)
        print("coordinates: \(str)")
        fetchNearestLocation(forId: str)
        
    }
}
