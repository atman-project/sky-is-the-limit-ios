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

    @Test func json_codable() async throws {
        let flight = Flight(departure_airport: "AMS", arrival_airport: "ICN", departure_localtime: ISO8601DateFormatter().date(from: "2025-06-01T21:25:00+02:00")!, arrival_localtime: ISO8601DateFormatter().date(from: "2025-06-02T16:25:00+09:00")!, airline: "KLM", aircraft: "B777-200", flight_number: "KL855", booking_reference: "ABCDEF")
        let dto = FlightDTO(from: flight)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(dto)
        print(String(data: data, encoding: .utf8)!)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(FlightDTO.self, from: data).toFlight()
        
        expectFlightsEqual(decoded, flight)
    }
    
    func expectFlightsEqual(_ lhs: Flight, _ rhs: Flight) {
        #expect(lhs.id == rhs.id)
        #expect(lhs.departure_airport == rhs.departure_airport)
        #expect(lhs.arrival_airport == rhs.arrival_airport)
        #expect(abs(lhs.departure_localtime.timeIntervalSince(rhs.departure_localtime)) == 0.0)
        #expect(abs(lhs.arrival_localtime.timeIntervalSince(rhs.arrival_localtime)) == 0.0)
        #expect(lhs.airline == rhs.airline)
        #expect(lhs.aircraft == rhs.aircraft)
        #expect(lhs.flight_number == rhs.flight_number)
        #expect(lhs.booking_reference == rhs.booking_reference)
    }
}
