//
//  FlightDetial.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/9/25.
//

import SwiftUI

struct FlightDetail: View {
    let flight: Flight
    
    var body: some View {
        let departureAirport = AirportProvider.shared.get(iata: flight.departureAirport)
        let arrivalAirport = AirportProvider.shared.get(iata: flight.arrivalAirport)
        
        List {
            Section {
                FlightDetailMap(departure: FlightLocation.from(airport: departureAirport), arrival: FlightLocation.from(airport: arrivalAirport))
                    .frame(height: 240)
                    .listRowInsets(EdgeInsets()) // full-width map
            }
            Section(header: Text("SUMMARY")) {
                keyValueRow("Route", "\(flight.departureAirport)-\(flight.arrivalAirport)")
                keyValueRow("Duration", Self.durationString(from: flight.departureLocalTime, to: flight.arrivalLocalTime))
                keyValueRow("Airline", flight.airline)
                keyValueRow("Flight Number", flight.flightNumber)
                keyValueRow("Aircraft", flight.aircraft)
                keyValueRow("Booking Reference", flight.bookingReference)
            }
            Section(header: Text("DEPARTURE")) {
                keyValueRow("City/Country", Self.city_and_country(airport: departureAirport))
                keyValueRow("Date/Time", flight.departureLocalTime.format(timezoneId: departureAirport?.tzDatabaseTimezone))
            }
            Section(header: Text("Arrival")) {
                keyValueRow("City/Country", Self.city_and_country(airport: arrivalAirport))
                keyValueRow("Date/Time", flight.arrivalLocalTime.format(timezoneId: arrivalAirport?.tzDatabaseTimezone))
            }
        }
        .navigationTitle("\(flight.departureAirport)-\(flight.arrivalAirport)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    static func city_and_country(airport: Airport?) -> String {
        return if let airport = airport {
            if let city = airport.city {
                "\(city), \(airport.country)"
            } else {
                "N/A"
            }
        } else {
            "N/A"
        }
    }
    
    func keyValueRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary).textSelection(.enabled)
        }
    }
    
    static func durationString(from start: Date, to end: Date) -> String {
        let interval = end.timeIntervalSince(start)
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
