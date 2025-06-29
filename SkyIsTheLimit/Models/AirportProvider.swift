//
//  AirportProvider.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import Foundation

final class AirportProvider {
    static let shared = AirportProvider()
    public var airports: [Airport] = []
    
    private init() {
        NSLog("loading airports")
        loadResource()
    }
    
    private func loadResource() {
        guard let url = Bundle.main.url(forResource: "airports", withExtension: "json") else {
            NSLog("❌ airports.json not found")
            return
        }
        NSLog("airport.json loaded successfully")
        
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([Airport].self, from: data)
            self.airports = result
            NSLog("✅ Loaded \(result.count) airports")
        } catch {
            NSLog("❌ Failed to decode airports.json: \(error)")
        }
    }
    
    func get(iata: String) -> Airport? {
        airports.first { $0.iata?.uppercased() == iata.uppercased() }
    }
}
