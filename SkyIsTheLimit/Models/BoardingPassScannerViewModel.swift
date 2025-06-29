//
//  BoardingPassScannerViewModel.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import SwiftUI
import Vision
import SwiftData

@MainActor
final class BoardingPassScannerViewModel: ObservableObject {

    @Published var isPresentingCamera = false
    @Published var lastError: String?

    // Entry point called by the SwiftUI view
    func addFlightFromCamera() {
        isPresentingCamera = true
    }

    // Handle the picked UIImage (photo just taken)
    func handleCapturedImage(_ uiImage: UIImage,
                             completion: @escaping (Flight?) -> Void) {
        Task {
            do {
                if let flight = try await analyzeImage(uiImage) {
                    completion(flight)
                } else {
                    lastError = "Nothing was scanned"
                    completion(nil)
                }
            } catch {
                lastError = error.localizedDescription
                completion(nil)
            }
        }
    }
}

// MARK: - Vision analysis
extension BoardingPassScannerViewModel {

    private enum ScannerError: LocalizedError { case unrecognizedFormat }

    /// Try barcode first (fast), fall back to OCR.
    private func analyzeImage(_ image: UIImage) async throws -> Flight? {
        // 1️⃣ BARCODE branch
        if let payload = try await decodeBarcode(in: image),
           let flight = BoardingPassParser.parseBCBP(payload) {
            return flight
        }
        
        // 2️⃣ OCR branch
        if let ocrText = try await recognizeText(in: image),
           let flight = BoardingPassParser.parseOCR(ocrText) {
            return flight
        }

        return nil
    }

    // PDF-417, Aztec, QR – Vision handles all.
    private func decodeBarcode(in image: UIImage) async throws -> String? {
        try await withCheckedThrowingContinuation { cont in
            let request = VNDetectBarcodesRequest { req, err in
                if let err = err { return cont.resume(throwing: err) }

                let payload = (req.results as? [VNBarcodeObservation])?
                    .compactMap { $0.payloadStringValue }
                    .first                   // grab first hit
                cont.resume(returning: payload)
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            try? handler.perform([request])
        }
    }

    /// Vision OCR → plain text blob
    private func recognizeText(in image: UIImage) async throws -> String? {
        try await withCheckedThrowingContinuation { cont in
            let request = VNRecognizeTextRequest { req, err in
                if let err = err { return cont.resume(throwing: err) }

                let text = (req.results as? [VNRecognizedTextObservation])?
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")
                cont.resume(returning: text)
            }
            request.recognitionLevel = .accurate
            request.revision = VNRecognizeTextRequestRevision3   // iOS 17+

            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            try? handler.perform([request])
        }
    }
}
