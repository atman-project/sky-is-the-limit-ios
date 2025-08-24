//
//  MainTabView.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            let syncmanDir = appSupportDir().appendingPathComponent("syncman")
            createDir(path: syncmanDir.path())
            let result = run_atman(syncmanDir.path())
            if result != 0 {
                let errorMessage = "Failed to initialize atman (error code: \(result))"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
            } else {
                initializeFlightsToAtman()
            }
        }
        .alert("Atman Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    MainTabView()
}

func appSupportDir() -> URL {
    FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
}

func createDir(path: String) {
    let mgr = FileManager.default
    if !mgr.fileExists(atPath: path) {
        try! mgr.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
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
