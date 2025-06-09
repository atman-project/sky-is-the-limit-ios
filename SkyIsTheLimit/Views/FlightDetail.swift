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
        VStack {
            Text("Flight: \(flight.flight_number)")
            Text("Departure: \(flight.departure_airport)")
            Text("DepartureLocaltime: \(flight.departure_localtime, format: Date.FormatStyle(date: .numeric, time: .standard))")
            Text("Arrival: \(flight.arrival_airport)")
            Text("ArrivalLocaltime: \(flight.arrival_localtime, format: Date.FormatStyle(date: .numeric, time: .standard))")
        }
    }
}
