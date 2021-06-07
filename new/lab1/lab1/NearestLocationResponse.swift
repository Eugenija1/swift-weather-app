//
//  NearestLocationResponse.swift
//  lab1
//
//  Created by Użytkownik Gość on 07/06/2021.
//

import Foundation

// MARK: - NearestLocationResponseElement
struct NearestLocationResponseElement: Codable {
    let distance: Int
    let title: String
    let locationType: LocationType
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case distance, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias NearestLocationResponse = [NearestLocationResponseElement]
