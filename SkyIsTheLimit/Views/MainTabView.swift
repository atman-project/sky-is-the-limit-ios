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

            guard let keys = KeyManager.getOrGenerateIdentityAndNetworkKey() else {
                let errorMessage = "Failed to generate or retrieve identity and network key"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
                return
            }
            print("Identity from Keychain: \(keys.identity)")
            print("Network key from Keychain: \(keys.networkKey)")

            let result = run_atman(keys.identity, keys.networkKey, nil, syncmanDir.path(), 3)
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

