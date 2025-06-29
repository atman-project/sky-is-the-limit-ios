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
        let departureAirport = AirportProvider.shared.get(iata: flight.departureAirport)
        
        HStack {
            FlightIcon(departure_airport: flight.departureAirport, arrival_airport: flight.arrivalAirport)
            VStack(alignment: .leading) {
                Text("\(flight.departureAirport) - \(flight.arrivalAirport)")
                    .font(.title3)
                Text("\(flight.departureLocalTime.format(timezoneId: departureAirport?.tzDatabaseTimezone))")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
