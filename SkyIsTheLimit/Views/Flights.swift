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
    @State private var showingAlert = false
    @State private var alertMessage = ""

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
                    print("Inserted flight to modelContext: \(flight)")
                    insertFlightToAtman(flight, index: 0)
                    print("Inserted flight to Atman: \(flight)")
                }
                isPresentingFlightForm = false
            }
        }
        .onAppear {
            switch loadFlightsFromAtman() {
            case .success(let loadedFlights):
                print("Loaded flights: \(loadedFlights)")
                let existingIDs = Set(flights.map(\.id))
                for flight in loadedFlights where !existingIDs.contains(flight.id) {
                    modelContext.insert(flight)
                    print("Inserted flight to modelContext: \(flight)")
                }
            case .failure(let error):
                print("Failed to load flights from Atman: \(error)")
                alertMessage = "Failed to load flights: \(error)"
                showingAlert = true
            }
        }
        .alert("Atman Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }

    private func deleteFlights(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(flights[index])
                print("Deleted flight from modelContext")
            }
        }
    }
}

enum AtmanError: Error {
    case commandFailed
    case decodeFailed(Error)
}

func loadFlightsFromAtman() -> Result<[Flight], AtmanError> {
    print("Loading flights from Atman")
    let docSpace = Array("aviation".utf8)
    let docId = Array("flights".utf8)
    return docSpace.withUnsafeBytes { docSpacePtr in
        docId.withUnsafeBytes { docIdPtr in
            let cmd = SyncGetCommand(
                doc_space: docSpacePtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                doc_space_len: UInt(docSpacePtr.count),
                doc_id: docIdPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                doc_id_len: UInt(docIdPtr.count)
            )
            if let jsonCstr = send_atman_sync_get_command(cmd) {
                let jsonStr = String(cString: jsonCstr)
                free_string(jsonCstr)
                do {
                    let data = Data(jsonStr.utf8)
                    let flights = try JSONDecoder().decode(FlightsDTO.self, from: data)
                    return .success(flights.toFlights())
                } catch {
                    return .failure(.decodeFailed(error))
                }
            } else {
                return .failure(.commandFailed)
            }
        }
    }
}

func insertFlightToAtman(_ flight: Flight, index: UInt) {
    guard let json = try? encodeToJSON(FlightDTO(from: flight)) else {
        print("JSON encoding failed")
        return
    }
    
    let docSpace = Array("aviation".utf8)
    let collectionDocId = Array("flights".utf8)
    let docId = Array("flight".utf8)
    let property = Array("flights".utf8)
    docSpace.withUnsafeBytes { docSpacePtr in
        collectionDocId.withUnsafeBytes { collectionDocIdPtr in
            docId.withUnsafeBytes { docIdPtr in
                property.withUnsafeBytes { propertyPtr in
                    withUnsafePointer(json) { dataPtr, dataLen in
                        let cmd = SyncListInsertCommand(
                            doc_space: docSpacePtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                            doc_space_len: UInt(docSpacePtr.count),
                            collection_doc_id: collectionDocIdPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                            collection_doc_id_len: UInt(docIdPtr.count),
                            doc_id: docIdPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                            doc_id_len: UInt(docIdPtr.count),
                            property: propertyPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                            property_len: UInt(propertyPtr.count),
                            data: dataPtr,
                            data_len: dataLen,
                            index: index,
                        )
                        send_atman_sync_list_insert_command(cmd)
                    }
                }
            }
        }
    }
}
