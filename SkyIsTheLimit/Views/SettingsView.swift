//
//  SettingsView.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingQRScanner = false
    @State private var isProcessing = false

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
                            Text("Connect to My Peer")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingQRScanner) {
                QRCodeScannerView(onCodeScanned: handleScannedQRCode)
            }
            .overlay {
                if isProcessing {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Connecting to peer...")
                                .font(.headline)
                        }
                        .padding(32)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 10)
                    }
                }
            }
        }
    }

    private func handleScannedQRCode(_ code: String) {
        showingQRScanner = false
        isProcessing = true

        Task {
            await processPeerConnection(code: code)
            isProcessing = false
        }
    }

    // TODO: Implement your peer connection job here
    private func processPeerConnection(code: String) async {
        print("Scanned QR Code: \(code): Connecting to the peer...")

        // Sleep for 5s to test ProgressView
        try? await Task.sleep(nanoseconds: 5_000_000_000)

        // Implement your async job here with the scanned code
        // Example: await networkService.connectToPeer(code)
    }
}
