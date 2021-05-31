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

    @Published private var model: WeatherModel = WeatherModel(cities: ["2459115": "New York", "2442047": "Los Angeles", "4118": "Toronto", "2295019": "New Delhi", "1105779": "Sydney", "44418": "London", "638243": "Berlin", "766273": "Madrid", "721943": "Rome", "615702": "Paris"])
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    private var cancellables: Set<AnyCancellable> = []
    private var fetcher: MetaWeatherFeatcher
    private let locationManager: CLLocationManager
    @Published var currentLocation: CLLocation?
    @Published var currentLocName: String = "City Name"
    
    func fetchWeather(forId woeid: String){
            fetcher.forecast(forId: woeid)
                .sink(receiveCompletion: {completion in
                    print(completion)
                }, receiveValue: { value in
                    //print(value)
                    self.model.refresh2(woeId: woeid, response: value)
                })
                .store(in: &cancellables)
    }
    
    override init(){
        locationManager = CLLocationManager()
        fetcher = MetaWeatherFeatcher()
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        for record in records{
            refresh(record: record)
        }
        print("current location \(String(describing: currentLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.last
        let geocoder = CLGeocoder()
        if let location = currentLocation{
            geocoder.reverseGeocodeLocation(location){
                placemarks, error in
                self.currentLocName = placemarks![0].locality!
            }
            
        }
    }
    
    
    func refresh(record: WeatherModel.WeatherRecord){
        fetchWeather(forId: record.woeId)
        //model.refresh(record: record)
    }
}
