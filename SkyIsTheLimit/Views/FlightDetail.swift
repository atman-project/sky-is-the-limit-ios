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
        let departure_airport = AirportProvider.shared.get(iata: flight.departure_airport)
        let arrival_airport = AirportProvider.shared.get(iata: flight.arrival_airport)
        
        List {
            Section {
                FlightDetailMap(departure: FlightLocation.from(airport: departure_airport), arrival: FlightLocation.from(airport: arrival_airport))
                    .frame(height: 240)
                    .listRowInsets(EdgeInsets()) // full-width map
            }
            Section(header: Text("SUMMARY")) {
                keyValueRow("Route", "\(flight.departure_airport)-\(flight.arrival_airport)")
                keyValueRow("Airline", flight.airline)
                keyValueRow("Flight Number", flight.flight_number)
                keyValueRow("Aircraft", flight.aircraft)
                keyValueRow("Booking Reference", flight.booking_reference)
            }
            Section(header: Text("DEPARTURE")) {
                keyValueRow("City/Country", Self.city_and_country(airport: departure_airport))
                keyValueRow("Date/Time", flight.departure_localtime.format(timezoneId: departure_airport?.tzDatabaseTimezone))
            }
            Section(header: Text("Arrival")) {
                keyValueRow("City/Country", Self.city_and_country(airport: arrival_airport))
                keyValueRow("Date/Time", flight.arrival_localtime.format(timezoneId: arrival_airport?.tzDatabaseTimezone))
            }
        }
        .navigationTitle("\(flight.departure_airport)-\(flight.arrival_airport)")
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
}
