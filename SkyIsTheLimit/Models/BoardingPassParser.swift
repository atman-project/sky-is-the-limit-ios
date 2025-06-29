//
//  BoardingPassParser.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import Foundation

enum BoardingPassParser {

    // MARK: IATA BCBP spec (PDF-417 payload)
    // Very rigid: fixed-width fields – easy!
    static func parseBCBP(_ raw: String) -> Flight? {
        print("parseBCBP: \(raw)")
        return nil
        
//        guard raw.hasPrefix("M") else { return nil }   // spec: always begins with 'M'
//
//        // Field offsets per IATA spec (simplified, single-segment boarding pass)
//        // Positions are 1-based in doc, so subtract 1 for Swift String indices.
//        func slice(_ start: Int, _ len: Int) -> String {
//            let s = raw.index(raw.startIndex, offsetBy: start)
//            let e = raw.index(s, offsetBy: len)
//            return String(raw[s..<e]).trimmingCharacters(in: .whitespaces)
//        }
//
//        let airlineCode      = slice(22, 3)           // e.g. "KE "
//        let flightNumber     = slice(25, 5)           // "0123 "
//        let fromIATA         = slice(30, 3)           // "ICN"
//        let toIATA           = slice(33, 3)           // "SFO"
//        let dayOfYearString  = slice(36, 3)           // "123"
//        let julian           = Int(dayOfYearString) ?? 1
//
//        // Quick-n-dirty date: assume current year
//        let calendar = Calendar(identifier: .gregorian)
//        let depart   = calendar.date(from: DateComponents(
//                          year: calendar.component(.year, from: .now),
//                          ordinalDay: julian)) ?? .now
//
//        // Aircraft, booking ref, … aren’t in mandatory block → set empty
//        return Flight(
//            departureAirport: fromIATA,
//            arrivalAirport: toIATA,
//            departureLocalTime: depart,
//            arrivalLocalTime: depart,          // unknown → override later
//            airline: airlineCode.trimmingCharacters(in: .whitespaces),
//            aircraft: "",
//            flightNumber: flightNumber.trimmingCharacters(in: .whitespaces),
//            bookingReference: ""
//        )
    }

    // MARK: OCR fallback (heuristic with regexes)
    static func parseOCR(_ text: String) -> Flight? {
        print("parseOCR: \(text)")
        return nil
    }
//        func firstMatch(_ pattern: String) -> String? {
//            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
//            return regex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
//                .flatMap { Range($0.range, in: text) }
//                .map { String(text[$0]) }
//        }
//
//        guard
//            let flightNo = firstMatch(#"[A-Z]{2}\s?\d{2,4}"#),      // e.g. "KE 85"
//            let from     = firstMatch(#"\b[A-Z]{3}\b"#),            // first IATA 3-letter
//            let to       = firstMatch(#"\b[A-Z]{3}\b"#, startingAt: from.endIndex, in: text)
//        else { return nil }
//
//        let ref  = firstMatch(#"[A-Z0-9]{6}"#) ?? ""
//        let date = Date()    // real impl: parse DDMMM (02JUL) or dd/MM
//
//        return Flight(
//            departureAirport: from,
//            arrivalAirport: to,
//            departureLocalTime: date,
//            arrivalLocalTime: date,
//            airline: String(flightNo.prefix(2)),
//            aircraft: "",
//            flightNumber: flightNo.replacingOccurrences(of: " ", with: ""),
//            bookingReference: ref
//        )
//    }

    // helper: same regex after a given index
//    private static func firstMatch(_ pattern: String,
//                                   startingAt idx: String.Index,
//                                   in text: String) -> String? {
//        let slice = String(text[idx...])
//        return firstMatch(pattern, in: slice)
//    }
}
