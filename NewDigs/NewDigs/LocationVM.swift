//
//  LocationMgr.swift
//  FindMe
//
//  Created by Arthur Roolfs on 10/31/22.
//

import CoreLocation
import MapKit
import SwiftUI

class LocationVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let lm: CLLocationManager
    
    @Published var location: CLLocation?
    @Published var authStatus: CLAuthorizationStatus
    @Published var enabled = false
    
    override init() {
        lm = CLLocationManager()
        authStatus = lm.authorizationStatus
        super.init()
        
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 10
        lm.delegate = self
    }
    
    // MARK: delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = lm.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            location = loc
        }
    }
    
    // MARK: ui
    func toggleService() {
        enabled.toggle()
        if enabled {
            lm.requestWhenInUseAuthorization()
            lm.startUpdatingLocation()
        } else {
            lm.stopUpdatingLocation()
            location = nil
        }
    }
}
