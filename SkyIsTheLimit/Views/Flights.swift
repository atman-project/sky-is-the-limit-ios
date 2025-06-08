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

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(flights) { flight in
                    NavigationLink {
                        Text("Flight at \(flight.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(flight.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
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
                    Button(action: addFlight) {
                        Label("Add Flight", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Flight")
        }
    }

    private func addFlight() {
        withAnimation {
            let newFlight = Flight(timestamp: Date())
            modelContext.insert(newFlight)
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
    let flight = Flight(timestamp: Date())
    container.mainContext.insert(flight)
    return Flights().modelContainer(container)
}
