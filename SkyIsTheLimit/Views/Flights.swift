//
//  Flights.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/2/25.
//

import SwiftUI
import SwiftData

struct Flights: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var flights: [Flight]
    @State private var isPresentingFlightForm = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(flights) { flight in
                    NavigationLink(destination: FlightDetail(flight: flight)) {
                        FlightRow(flight: flight)
                    }
                }
                .onDelete(perform: deleteFlights)
            }
            .listStyle(.inset)
            .navigationTitle("Flights")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isPresentingFlightForm = true }) {
                        Label("Add Flight", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Flight")
        }
        .sheet(isPresented: $isPresentingFlightForm) {
            FlightForm(onSubmit: { flight in
                withAnimation {
                    modelContext.insert(flight)
                    if let json = try? encodeToJSON(FlightDTO(from: flight)) {
                        withUnsafePointer(json) { ptr, len in
                            send_atman_core_message(ptr, len)
                        }
                    } else {
                        print("JSON encoding failed")
                    }
                }
                isPresentingFlightForm = false
            }, modelContext: modelContext)
        }
    }

    private func deleteFlights(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(flights[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Flight.self, configurations: config)
    let flight = Flight(departure_airport: "AMS", arrival_airport: "ICN", departure_localtime: ISO8601DateFormatter().date(from: "2025-06-01T21:25:00+02:00")!, arrival_localtime: ISO8601DateFormatter().date(from: "2025-06-02T16:25:00+09:00")!, airline: "KLM", aircraft: "B777-200", flight_number: "KL855", booking_reference: "ABCEDF")
    container.mainContext.insert(flight)
    return Flights().modelContainer(container)
}
