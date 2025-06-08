//
//  FlightRow.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/8/25.
//

import SwiftUI

struct FlightRow: View {
    var flight: Flight
    
    var body: some View {
        HStack {
            FlightIcon(departure_airport: flight.departure_airport, arrival_airport: flight.arrival_airport)
            VStack(alignment: .leading) {
                Text("\(flight.departure_airport) - \(flight.arrival_airport)")
                    .font(.title3)
                Text("\(flight.departure_localtime, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
