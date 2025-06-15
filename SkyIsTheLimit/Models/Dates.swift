//
//  Dates.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import Foundation

extension Date {
    func format(timezoneId: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm (XXX)"
        if let timezone = timezoneId {
            formatter.timeZone = TimeZone(identifier: timezone) ?? .current
        } else {
            formatter.timeZone = .current
        }
        return formatter.string(from: self)
    }
}


