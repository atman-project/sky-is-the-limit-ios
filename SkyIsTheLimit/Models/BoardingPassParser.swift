//
//  BoardingPassParser.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import Foundation

enum BoardingPassParser {

    // MARK: IATA BCBP spec (PDF-417 payload)
    static func parseBCBP(_ raw: String) -> Flight? {
        print("parseBCBP: \(raw)")
        
        guard raw.hasPrefix("M") else { return nil }   // spec: always begins with 'M'

        func slice(_ start: Int, _ len: Int) -> String {
            let s = raw.index(raw.startIndex, offsetBy: start)
            let e = raw.index(s, offsetBy: len)
            return String(raw[s..<e]).trimmingCharacters(in: .whitespaces)
        }

        let departureIATA = slice(30, 3) // "ICN"
        let arrivalIATA = slice(33, 3) // "SFO"
        let airlineCode = slice(36, 2) // "KE"
        let flightNumber = slice(39, 4) // "0123"
        let dayOfYear = Int(slice(44, 3)) ?? 1 // "198" (17 Jul)
        
        let departureAirport = AirportProvider.shared.get(iata: departureIATA)

        // Quick-n-dirty: Convert dayOfYear to Date, assuming current year
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: .now)
        var comps = DateComponents()
        comps.calendar = calendar
        comps.year = year
        comps.dayOfYear = dayOfYear
        comps.hour = 12
        comps.minute = 0
        comps.timeZone = TimeZone(identifier: departureAirport?.tzDatabaseTimezone ?? "UTC")
        let depart = calendar.date(from: comps) ?? .now
        
        return Flight(
            departure_airport: departureIATA,
            arrival_airport: arrivalIATA,
            departure_localtime: depart,
            // Just setting the arrival time the same as the departure time
            arrival_localtime: depart,
            airline: "UNKNOWN",
            aircraft: "UNKNOWN",
            flight_number: "\(airlineCode)\(flightNumber)",
            booking_reference: "UNKNOWN",
        )
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
