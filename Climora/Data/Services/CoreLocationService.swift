//
//  CoreLocationService.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import ObjectiveC
import CoreLocation
import Combine

protocol LocationService {
    func requestLocation()
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    var permissionDeniedPublisher: AnyPublisher<Void, Never> { get }
}

final class CoreLocationService: NSObject, LocationService {

    private let manager = CLLocationManager()
    private let subject = PassthroughSubject<CLLocation, Never>()
    private let permissionSubject = PassthroughSubject<Void, Never>()

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        subject.eraseToAnyPublisher()
    }

    var permissionDeniedPublisher: AnyPublisher<Void, Never> {
        permissionSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        
        case .denied, .restricted:
            print("Location permission denied or restricted")
            permissionSubject.send()
        
        @unknown default:
            break
        }
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            print("Location permission denied")
            permissionSubject.send()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            subject.send(location)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Location error:", error)
    }
}
