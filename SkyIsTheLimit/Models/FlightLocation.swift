//
//  FlightLocation.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/9/25.
//

import Foundation

struct FlightLocation {
    var latitude: Double
    var longitude: Double
    
    static func from(airport: Airport?) -> Self {
        return if let airport = airport {
            FlightLocation(latitude: airport.latitude, longitude: airport.longitude)
        } else {
            FlightLocation(latitude: 0, longitude: 0)
        }
    }
}
