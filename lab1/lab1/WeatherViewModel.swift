//
//  WeatherViewModel.swift
//  lab1
//
//  Created by AppleLab on 05/05/2021.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published private(set) var model: WeatherModel = WeatherModel(cities:["Minsk", "Warsaw", "Paris",
    "Barcelona", "Berlin", "London", "Sydney", "Rome", "Prague", "Grodno", "Brest"])
    
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord){
        model.refresh(record: record)
    }
}
