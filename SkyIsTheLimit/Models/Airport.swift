//
//  Airport.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import Foundation

struct Airport: Codable, Identifiable {
    let airportID: Int
    let name: String
    let city: String?
    let country: String
    let iata: String?
    let icao: String?
    let latitude: Double
    let longitude: Double
    let altitude: Int
    let timezone: String
    let dst: String
    let tzDatabaseTimezone: String
    let type: String
    let source: String
    
    var id: Int { airportID }

    // Map from JSON keys
    enum CodingKeys: String, CodingKey {
        case airportID = "Airport ID"
        case name = "Name"
        case city = "City"
        case country = "Country"
        case iata = "IATA"
        case icao = "ICAO"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case altitude = "Altitude"
        case timezone = "Timezone"
        case dst = "DST"
        case tzDatabaseTimezone = "Tz database timezone"
        case type = "Type"
        case source = "Source"
    }
}
