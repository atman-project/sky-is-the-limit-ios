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
