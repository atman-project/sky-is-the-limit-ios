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
            FlightForm { flight in
                withAnimation {
                    modelContext.insert(flight)
                    sendFlightToAtman(flight)
                }
                isPresentingFlightForm = false
            }
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

func sendFlightToAtman(_ flight: Flight) {
    guard let json = try? encodeToJSON(FlightDTO(from: flight)) else {
        print("JSON encoding failed")
        return
    }
    
    let docSpace = Array("/air".utf8)
    let docId = Array("flights".utf8)
    docSpace.withUnsafeBytes { docSpacePtr in
        docId.withUnsafeBytes { docIdPtr in
            withUnsafePointer(json) { dataPtr, dataLen in
                let cmd = SyncUpdateCommand(
                    doc_space: docSpacePtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    doc_space_len: UInt(docSpacePtr.count),
                    doc_id: docIdPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    doc_id_len: UInt(docIdPtr.count),
                    data: dataPtr,
                    data_len: dataLen,
                )
                send_atman_sync_update_command(cmd)
            }
        }
    }
}
