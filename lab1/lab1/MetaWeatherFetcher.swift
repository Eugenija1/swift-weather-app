//
//  MetaWeatherFetcher.swift
//  lab1
//
//  Created by AppleLab on 19/05/2021.
//

import Foundation
import Combine

class MetaWeatherFeatcher{
    
    func forecast(forId woeId: String) ->
        
        AnyPublisher<MetaWeatherRepsonse, Error>{
            var url = "https://www.metaweather.com/api/location/" + woeId
            let url2 = URL(string: url)!
            //let url2 = URL(string:"https://www.metaweather.com/api/location/2487956")!
        return URLSession.shared.dataTaskPublisher(for: url2)
            .map {$0.data}
            .decode(type: MetaWeatherRepsonse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        }
    
}
