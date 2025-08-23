//
//  MainTabView.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Flights().tabItem {
                Label("Flights", systemImage: "airplane")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .onAppear {
            run_atman()
            initializeFlightsToAtman()
        }
    }
}

#Preview {
    MainTabView()
}

func initializeFlightsToAtman() {
    guard let json = try? encodeToJSON(FlightsDTO(flights: [])) else {
        print("JSON encoding failed")
        return
    }
    
    let docSpace = Array("/aviation".utf8)
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
