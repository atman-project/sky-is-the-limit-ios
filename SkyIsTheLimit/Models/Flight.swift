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
    var departureAirport: String
    var arrivalAirport: String
    var departureLocalTime: Date
    var arrivalLocalTime: Date
    var airline: String
    var aircraft: String
    var flightNumber: String
    var bookingReference: String

    init(id: UUID = UUID(), departureAirport: String, arrivalAirport: String, departureLocalTime: Date, arrivalLocalTime: Date, airline: String, aircraft: String, flightNumber: String, bookingReference: String) {
        self.id = id
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.departureLocalTime = departureLocalTime
        self.arrivalLocalTime = arrivalLocalTime
        self.airline = airline
        self.aircraft = aircraft
        self.flightNumber = flightNumber
        self.bookingReference = bookingReference
    }

}

struct FlightDTO: Codable {
    var id: UUID
    var departureAirport: String
    var arrivalAirport: String
    var departureLocalTime: Date
    var arrivalLocalTime: Date
    var airline: String
    var aircraft: String
    var flightNumber: String
    var bookingReference: String

    init(from flight: Flight) {
        self.id = flight.id
        self.departureAirport = flight.departureAirport
        self.arrivalAirport = flight.arrivalAirport
        self.departureLocalTime = flight.departureLocalTime
        self.arrivalLocalTime = flight.arrivalLocalTime
        self.airline = flight.airline
        self.aircraft = flight.aircraft
        self.flightNumber = flight.flightNumber
        self.bookingReference = flight.bookingReference
    }
}

extension FlightDTO {
    /// Converts this data‑transfer object back into a persisted `Flight` model.
    func toFlight() -> Flight {
        Flight(id: self.id,
               departureAirport: self.departureAirport,
               arrivalAirport: self.arrivalAirport,
               departureLocalTime: self.departureLocalTime,
               arrivalLocalTime: self.arrivalLocalTime,
               airline: self.airline,
               aircraft: self.aircraft,
               flightNumber: self.flightNumber,
               bookingReference: self.bookingReference)
    }
}
