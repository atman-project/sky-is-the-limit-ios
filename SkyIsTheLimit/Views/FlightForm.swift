//
//  FlightForm.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import SwiftUI
import Vision
import SwiftData

struct FlightForm: View {
    var onSubmit: (Flight) -> Void
    var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var scannerVM: BoardingPassScannerViewModel
    @State private var showScanner = false
    @State private var showAlertScannedFlight = false

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

    init(onSubmit: @escaping (Flight) -> Void, modelContext: ModelContext) {
        self.onSubmit = onSubmit
        self.modelContext = modelContext
        _scannerVM = StateObject(wrappedValue: BoardingPassScannerViewModel(context: modelContext))
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button {
                        showScanner = true
                    } label: {
                        Label("Scan Boarding Pass", systemImage: "camera")
                    }
                    .fullScreenCover(isPresented: $showScanner) {
                        CameraSheet { image in
                            scannerVM.handleCapturedImage(image) { parsed in
                                if let parsed = parsed {
                                    departureAirport = parsed.departureAirport
                                    arrivalAirport = parsed.arrivalAirport
                                    departureTime = parsed.departureLocalTime
                                    arrivalTime = parsed.arrivalLocalTime
                                    airline = parsed.airline
                                    aircraft = parsed.aircraft
                                    flightNumber = parsed.flightNumber
                                    bookingReference = parsed.bookingReference
                                    showAlertScannedFlight = true
                                }
                            }
                        }
                    }
                    .alert("Boarding Pass Scanned", isPresented: $showAlertScannedFlight) {
                        Button("OK", role: .cancel) { showAlertScannedFlight = false }
                    } message: {
                        Text("Flight details have been filled from the scanned boarding pass, but check details manually.")
                    }
                    .alert("Scan Error", isPresented: Binding<Bool>(
                        get: { scannerVM.lastError != nil },
                        set: { if !$0 { scannerVM.lastError = nil } }
                    ), actions: {
                        Button("OK", role: .cancel) { scannerVM.lastError = nil }
                    }, message: {
                        Text(scannerVM.lastError ?? "")
                    })
                }
                
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
                            departureAirport: departureAirport,
                            arrivalAirport: arrivalAirport,
                            departureLocalTime: departureTime,
                            arrivalLocalTime: arrivalTime,
                            airline: airline,
                            aircraft: aircraft,
                            flightNumber: flightNumber,
                            bookingReference: bookingReference
                        )
                        onSubmit(flight)
                    }
                }
            }
        }
    }
}
