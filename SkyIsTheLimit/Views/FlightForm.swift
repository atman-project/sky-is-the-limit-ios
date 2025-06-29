//
//  FlightForm.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import SwiftUI

struct FlightForm: View {
    var onSubmit: (Flight) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var departureAirport = ""
    @State private var arrivalAirport = ""
    @State private var departureTime = Date()
    @State private var arrivalTime = Date()
    @State private var airline = ""
    @State private var aircraft = ""
    @State private var flightNumber = ""
    @State private var bookingReference = ""
    
    // Which text field is active?
    @FocusState private var focused: Field?
    private enum Field { case dep, arr }

    // Live suggestions
    private var depSuggestions: [Airport] {
        guard !departureAirport.isEmpty else { return [] }
        return AirportProvider.shared.airports
            .compactMap { airport in
                guard let code = airport.iata?.lowercased(), code.hasPrefix(departureAirport.lowercased()) else {
                    return nil
                }
                return airport
            }
    }
    private var arrSuggestions: [Airport] {
        guard !arrivalAirport.isEmpty else { return [] }
        return AirportProvider.shared.airports
            .compactMap { airport in
                guard let code = airport.iata?.lowercased(), code.hasPrefix(arrivalAirport.lowercased()) else {
                    return nil
                }
                return airport
            }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("DEPARTURE")) {
                    LabeledContent("Airport") {
                        TextField("ICN", text: $departureAirport)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .dep)
                    }

                    if focused == .dep {
                        ForEach(depSuggestions, id: \.iata) { ap in
                            Button {
                                departureAirport = ap.iata ?? ""
                                focused = .arr
                            } label: {
                                HStack {
                                    Text(ap.iata ?? "").bold()
                                    Text(ap.name).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    DatePicker("Date / Time", selection: $departureTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }

                Section(header: Text("ARRIVAL")) {
                    LabeledContent("Airport") {
                        TextField("CDG", text: $arrivalAirport)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .arr)
                    }

                    if focused == .arr {
                        ForEach(arrSuggestions, id: \.iata) { ap in
                            Button {
                                arrivalAirport = ap.iata ?? ""
                                focused = nil
                            } label: {
                                HStack {
                                    Text(ap.iata ?? "").bold()
                                    Text(ap.name).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    
                    DatePicker("Date / Time", selection: $arrivalTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }

                Section(header: Text("FLIGHT DETAILS")) {
                    LabeledContent("Flight Number") {
                        TextField("KE1234", text: $flightNumber)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                    }
                    LabeledContent("Airline") {
                        TextField("Korean Air", text: $airline)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                    }
                    LabeledContent("Aircraft") {
                        TextField("A380-800", text: $aircraft)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                    }
                    LabeledContent("Booking Reference") {
                        TextField("ABCDEF", text: $bookingReference)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                    }
                }
            }
            .navigationTitle("New Flight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let flight = Flight(
                            departure_airport: departureAirport,
                            arrival_airport: arrivalAirport,
                            departure_localtime: departureTime,
                            arrival_localtime: arrivalTime,
                            airline: airline,
                            aircraft: aircraft,
                            flight_number: flightNumber,
                            booking_reference: bookingReference
                        )
                        onSubmit(flight)
                    }
                }
            }
        }
    }
}
