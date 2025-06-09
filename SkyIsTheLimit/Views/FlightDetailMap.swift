//
//  FlightDetailMap.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/9/25.
//

import SwiftUI
import MapKit

struct FlightDetailMap: View {
    let departure: FlightLocation
    let arrival: FlightLocation
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            Marker("FROM", coordinate: departure.coordinate).tint(.blue)
            Marker("TO", coordinate: arrival.coordinate).tint(.red)
            MapPolyline(points: [
                MKMapPoint(departure.coordinate),
                MKMapPoint(arrival.coordinate)
            ])
            .stroke(.black, lineWidth: 3)
        }
        .onAppear {
            withAnimation {
                let center = CLLocationCoordinate2D(
                    latitude: (departure.latitude + arrival.latitude) / 2,
                    longitude: (departure.longitude + arrival.longitude) / 2
                )
                let span = MKCoordinateSpan(latitudeDelta: abs(departure.latitude - arrival.latitude) * 1.5 + 0.5,
                                            longitudeDelta: abs(departure.longitude - arrival.longitude) * 1.5 + 0.5)
                position = .region(MKCoordinateRegion(center: center, span: span))
            }
        }
    }
}

extension FlightLocation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
