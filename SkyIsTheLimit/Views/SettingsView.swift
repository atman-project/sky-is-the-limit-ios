//
//  SettingsView.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingQRScanner = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        showingQRScanner = true
                    }) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.blue)
                            Text("Connect to Peer")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingQRScanner) {
                QRCodeScannerView(onCodeScanned: handleScannedQRCode)
            }
        }
    }

    // Placeholder function for handling scanned QR code
    // You can implement this function to handle the scanned code
    private func handleScannedQRCode(_ code: String) {
        showingQRScanner = false
        // TODO: Implement your job here with the scanned code
        print("Scanned QR Code: \(code)")
    }
}
