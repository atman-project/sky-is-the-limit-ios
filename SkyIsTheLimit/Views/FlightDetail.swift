//
//  FlightDetial.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/9/25.
//

import SwiftUI

struct FlightDetail: View {
    let flight: Flight
    @State private var departure_location: FlightLocation =  FlightLocation(latitude: 52.3125060567449, longitude: 4.745581811167513)
    @State private var arrival_location: FlightLocation =  FlightLocation(latitude: 37.4587, longitude: 126.4420)

    var body: some View {
        let departure_airport = AirportProvider.shared.get(iata: flight.departure_airport)
        let arrival_airport = AirportProvider.shared.get(iata: flight.arrival_airport)
        
        VStack {
            FlightDetailMap(departure: departure_location, arrival: arrival_location)
                .ignoresSafeArea(.container)
            Text("Flight: \(flight.flight_number)")
            Text("Departure: \(flight.departure_airport)")
            Text("DepartureLocaltime: \(flight.departure_localtime.format(timezoneId: departure_airport?.tzDatabaseTimezone))")
            Text("Arrival: \(flight.arrival_airport)")
            Text("ArrivalLocaltime: \(flight.arrival_localtime.format(timezoneId: arrival_airport?.tzDatabaseTimezone))")
        }
    }
}
