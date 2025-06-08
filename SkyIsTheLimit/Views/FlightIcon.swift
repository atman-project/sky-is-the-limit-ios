//
//  FlightIcon.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/8/25.
//

import SwiftUI

struct FlightIcon: View {
    var departure_airport: String
    var arrival_airport: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.black)
            .frame(width: 60, height: 60)
            .overlay {
                VStack(spacing: 2) {
                    Text("\(departure_airport)")
                    Text("\(arrival_airport)")
                }
                .bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            }

    }
}
