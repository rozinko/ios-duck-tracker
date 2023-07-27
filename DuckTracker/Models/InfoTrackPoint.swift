import Foundation
import MapKit

public struct InfoTrackPoint: Identifiable {
    public let id: UUID = UUID()

    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    let altitude: CLLocationDistance
    let speed: CLLocationSpeed
    let course: CLLocationDirection

    let hAcc: CLLocationAccuracy
    let vAcc: CLLocationAccuracy
    let sAcc: CLLocationSpeedAccuracy

    let distance: CLLocationDistance

    let timestamp: Date
}
