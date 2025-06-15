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
        
        VStack {
            FlightDetailMap(departure: FlightLocation.from(airport: departure_airport), arrival: FlightLocation.from(airport: arrival_airport))
                .ignoresSafeArea(.container)
            Text("Flight: \(flight.flight_number)")
            Text("Departure: \(flight.departure_airport)")
            Text("DepartureLocaltime: \(flight.departure_localtime.format(timezoneId: departure_airport?.tzDatabaseTimezone))")
            Text("Arrival: \(flight.arrival_airport)")
            Text("ArrivalLocaltime: \(flight.arrival_localtime.format(timezoneId: arrival_airport?.tzDatabaseTimezone))")
        }
    }
}
