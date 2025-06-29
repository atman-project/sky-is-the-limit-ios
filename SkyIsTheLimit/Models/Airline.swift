//
//  Airline.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import Foundation

struct Airline: Codable, Identifiable {
    let id: Int
    let name: String
    let code: String?
}
