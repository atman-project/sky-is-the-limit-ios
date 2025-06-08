//
//  SkyIsTheLimitApp.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/2/25.
//

import SwiftUI
import SwiftData

@main
struct SkyIsTheLimitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Flight.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Flights()
        }
        .modelContainer(sharedModelContainer)
    }
}
