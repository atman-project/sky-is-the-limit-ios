//
//  QRCodeScannerView.swift
//  SkyIsTheLimit
//
//  Created by Claude Code
//

import SwiftUI
import VisionKit

struct QRCodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    let onCodeScanned: (String) -> Void

    var body: some View {
        DataScannerRepresentable(onCodeScanned: { code in
            onCodeScanned(code)
        })
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Button("Cancel") {
                dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.black.opacity(0.5))
            .cornerRadius(8)
            .padding()
        }
    }
}

struct DataScannerRepresentable: UIViewControllerRepresentable {
    let onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        try? uiViewController.startScanning()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeScanned: onCodeScanned)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onCodeScanned: (String) -> Void

        init(onCodeScanned: @escaping (String) -> Void) {
            self.onCodeScanned = onCodeScanned
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                if let stringValue = barcode.payloadStringValue {
                    onCodeScanned(stringValue)
                }
            default:
                break
            }
        }
    }
}
