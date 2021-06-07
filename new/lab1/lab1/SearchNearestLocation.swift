//
//  SearchNearestLocation.swift
//  lab1
//
//  Created by Użytkownik Gość on 07/06/2021.
//

import Foundation
import Combine

class SearchNearestLocation{
    
    func forecast(forId coordinates: String) -> AnyPublisher<NearestLocationResponse,Error>
    {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(coordinates)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: NearestLocationResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
