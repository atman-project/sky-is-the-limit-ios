//
//  Flight.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/2/25.
//

import Foundation
import SwiftData

@Model
final class Flight: Identifiable {
    var id: UUID
    var departure_airport: String
    var arrival_airport: String
    var departure_localtime: Date
    var arrival_localtime: Date
    var airline: String
    var aircraft: String
    var flight_number: String
    var booking_reference: String

    init(id: UUID = UUID(), departure_airport: String, arrival_airport: String, departure_localtime: Date, arrival_localtime: Date, airline: String, aircraft: String, flight_number: String, booking_reference: String) {
        self.id = id
        self.departure_airport = departure_airport
        self.arrival_airport = arrival_airport
        self.departure_localtime = departure_localtime
        self.arrival_localtime = arrival_localtime
        self.airline = airline
        self.aircraft = aircraft
        self.flight_number = flight_number
        self.booking_reference = booking_reference
    }

}

struct FlightDTO: Codable {
    var id: UUID
    var departure_airport: String
    var arrival_airport: String
    var departure_localtime: Date
    var arrival_localtime: Date
    var airline: String
    var aircraft: String
    var flight_number: String
    var booking_reference: String

    init(from flight: Flight) {
        self.id = flight.id
        self.departure_airport = flight.departure_airport
        self.arrival_airport = flight.arrival_airport
        self.departure_localtime = flight.departure_localtime
        self.arrival_localtime = flight.arrival_localtime
        self.airline = flight.airline
        self.aircraft = flight.aircraft
        self.flight_number = flight.flight_number
        self.booking_reference = flight.booking_reference
    }
}

extension FlightDTO {
    /// Converts this data‑transfer object back into a persisted `Flight` model.
    func toFlight() -> Flight {
        Flight(id: self.id,
               departure_airport: self.departure_airport,
               arrival_airport: self.arrival_airport,
               departure_localtime: self.departure_localtime,
               arrival_localtime: self.arrival_localtime,
               airline: self.airline,
               aircraft: self.aircraft,
               flight_number: self.flight_number,
               booking_reference: self.booking_reference)
    }
}

