//
//  FlightTest.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import Testing
@testable import SkyIsTheLimit
import Foundation

struct FlightTest {

    @Test func jsonCodable() async throws {
        let flight = Flight(departureAirport: "AMS", arrivalAirport: "ICN", departureLocalTime: ISO8601DateFormatter().date(from: "2025-06-01T21:25:00+02:00")!, arrivalLocalTime: ISO8601DateFormatter().date(from: "2025-06-02T16:25:00+09:00")!, airline: "KLM", aircraft: "B777-200", flightNumber: "KL855", bookingReference: "ABCDEF")
        let dto = FlightDTO(from: flight)

        let data = try encodeToJSON(dto)
        print(String(data: data, encoding: .utf8)!)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(FlightDTO.self, from: data).toFlight()
        
        expectFlightsEqual(decoded, flight)
    }
    
    @Test func emptyFlightsJsonCodable() async throws {
        let flightsDTO = FlightsDTO(flights: [])
        
        let data = try encodeToJSON(flightsDTO)
        let jsonString = String(data: data, encoding: .utf8)!
        print("FlightsDTO JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(FlightsDTO.self, from: data)
        
        #expect(decoded.flights.count == 0)
    }
    
    @Test func flightsJsonCodable() async throws {
        let flight1 = Flight(departureAirport: "AMS", arrivalAirport: "ICN", departureLocalTime: ISO8601DateFormatter().date(from: "2025-06-01T21:25:00+02:00")!, arrivalLocalTime: ISO8601DateFormatter().date(from: "2025-06-02T16:25:00+09:00")!, airline: "KLM", aircraft: "B777-200", flightNumber: "KL855", bookingReference: "ABCDEF")
        let flight2 = Flight(departureAirport: "ICN", arrivalAirport: "LAX", departureLocalTime: ISO8601DateFormatter().date(from: "2025-06-03T10:30:00+09:00")!, arrivalLocalTime: ISO8601DateFormatter().date(from: "2025-06-03T05:45:00-08:00")!, airline: "Korean Air", aircraft: "A380", flightNumber: "KE17", bookingReference: "GHIJKL")
        
        let dto1 = FlightDTO(from: flight1)
        let dto2 = FlightDTO(from: flight2)
        let flightsDTO = FlightsDTO(flights: [dto1, dto2])

        let data = try encodeToJSON(flightsDTO)
        let jsonString = String(data: data, encoding: .utf8)!
        print("FlightsDTO JSON: \(jsonString)")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(FlightsDTO.self, from: data)
        
        #expect(decoded.flights.count == 2)
        expectFlightsEqual(decoded.flights[0].toFlight(), flight1)
        expectFlightsEqual(decoded.flights[1].toFlight(), flight2)
    }
    
    func expectFlightsEqual(_ lhs: Flight, _ rhs: Flight) {
        #expect(lhs.id == rhs.id)
        #expect(lhs.departureAirport == rhs.departureAirport)
        #expect(lhs.arrivalAirport == rhs.arrivalAirport)
        #expect(abs(lhs.departureLocalTime.timeIntervalSince(rhs.departureLocalTime)) == 0.0)
        #expect(abs(lhs.arrivalLocalTime.timeIntervalSince(rhs.arrivalLocalTime)) == 0.0)
        #expect(lhs.airline == rhs.airline)
        #expect(lhs.aircraft == rhs.aircraft)
        #expect(lhs.flightNumber == rhs.flightNumber)
        #expect(lhs.bookingReference == rhs.bookingReference)
    }
}
