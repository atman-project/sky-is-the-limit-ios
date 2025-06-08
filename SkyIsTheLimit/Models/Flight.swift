//
//  Flight.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/2/25.
//

import Foundation
import SwiftData

@Model
final class Flight {
    var departure_airport: String
    var arrival_airport: String
    var departure_localtime: Date
    var arrival_localtime: Date
    var airline: String
    var aircraft: String
    var flight_number: String

    init(departure_airport: String, arrival_airport: String, departure_localtime: Date, arrival_localtime: Date, airline: String, aircraft: String, flight_number: String) {
        self.departure_airport = departure_airport
        self.arrival_airport = arrival_airport
        self.departure_localtime = departure_localtime
        self.arrival_localtime = arrival_localtime
        self.airline = airline
        self.aircraft = aircraft
        self.flight_number = flight_number
    }
}
