import Foundation
import Combine
import CoreLocation

class LocHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    @Published var lat: Double? = nil
    @Published var lng: Double? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        if loc != nil {
            lat = loc!.coordinate.latitude
            lng = loc!.coordinate.longitude
        }
    }
}
