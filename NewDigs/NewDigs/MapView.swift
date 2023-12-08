//
//  MapView.swift
//  NewDigs
//
//  Created by Arthur Roolfs on 11/1/22.
//

import SwiftUI
import MapKit

// for use with markers
struct Marker: Identifiable {
    var id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    
    @State var location: CLLocation
    let dist = 0.001
    
    private var region: Binding<MKCoordinateRegion> {
        Binding {
            MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: dist, longitudeDelta: dist))
        } set: { _ in }
    }
    
    var body: some View {
        
        // simple
//        VStack {
//            Map(coordinateRegion: region, showsUserLocation: true)
//                .padding()
//        }
        
        // use markers - comment out VStack above
        let pins = [
            Marker(coordinate: location.coordinate)
        ]

        VStack {
            Map(coordinateRegion: region, annotationItems: pins) {
                MapMarker(coordinate: $0.coordinate)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: CLLocation(latitude: 43.16103, longitude: -77.6109219))
    }
}
