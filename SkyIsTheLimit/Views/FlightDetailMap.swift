//
//  FlightDetailMap.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/9/25.
//

import SwiftUI
import MapKit

struct FlightDetailMap: View {
    let location: FlightLocation
    let tintColor: Color
    private var place: FlightPlace
    @State private var position: MapCameraPosition = .automatic
    
    init(location: FlightLocation, tintColor: Color) {
        self.location = location
        self.tintColor = tintColor
        self.place = FlightPlace(location: location)
    }
    
    var body: some View {
        Map(position: $position) {
            Marker("", coordinate: place.location).tint(tintColor)
        }
        .onAppear {
            withAnimation {
                var region = MKCoordinateRegion()
                region.center = place.location
                region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                position = .region(region)
            }
        }
    }
}

struct FlightPlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: FlightLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
