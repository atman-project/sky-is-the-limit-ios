//
//  AirlineProvider.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import Foundation

final class AirlineProvider {
    static let shared = AirlineProvider()
    public var airlines: [Airline] = []
    
    private init() {
        NSLog("loading airlines")
        loadResource()
    }
    
    private func loadResource() {
        guard let url = Bundle.main.url(forResource: "airlines", withExtension: "json") else {
            NSLog("❌ airlines.json not found")
            return
        }
        NSLog("airlines.json loaded successfully")
        
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([Airline].self, from: data)
            self.airlines = result
            NSLog("✅ Loaded \(result.count) airlines")
        } catch {
            NSLog("❌ Failed to decode airlines.json: \(error)")
        }
    }
    
    func get(code: String) -> Airline? {
        airlines.first { $0.code?.uppercased() == code.uppercased() }
    }
}
