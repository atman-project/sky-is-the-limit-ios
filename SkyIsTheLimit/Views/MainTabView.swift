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

            // Get or generate the Ed25519 network key (persisted in Keychain)
            guard let networkKey = KeyManager.getOrGenerateNetworkKey() else {
                let errorMessage = "Failed to generate or retrieve network key"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
                return
            }

            print("Network key (Ed25519 private key): \(networkKey)")

            // TODO: use the real identity key
            // TODO: Once run_atman accepts network_key parameter, pass networkKey here
            let result = run_atman("e6b5f2694334c26a7f02062b99ab7735f4acc97c017502e0d7490331540ab1bc", syncmanDir.path(), 3)
            if result != 0 {
                let errorMessage = "Failed to initialize atman (error code: \(result))"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
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

