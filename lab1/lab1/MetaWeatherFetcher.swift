//
//  MetaWeatherFetcher.swift
//  lab1
//
//  Created by AppleLab on 19/05/2021.
//

import Foundation
import Combine

class MetaWeatherFeatcher{
    
    func forecast(forId woeId: String) -> AnyPublisher<MetaWeatherRepsonse,Error>
    {
        let url = URL(string: "https://www.metaweather.com/api/location/\(woeId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: MetaWeatherRepsonse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
