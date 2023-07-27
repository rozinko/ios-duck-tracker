import Foundation
import MapKit

public struct TrackPoint: Identifiable {
    public let id = UUID()

    let location: CLLocation
    let distance: CLLocationDistance?

    var latitude: CLLocationDegrees { location.coordinate.latitude }
    var longitude: CLLocationDegrees { location.coordinate.longitude }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    init(location: CLLocation) {
        self.location = location
        self.distance = nil
    }

    init(location: CLLocation, previousTrackPoint prev: TrackPoint?) {
        self.location = location
        self.distance = prev != nil ? location.distance(from: prev!.location) : nil
    }
}
