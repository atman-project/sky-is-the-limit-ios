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
            Text("Icon")
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
