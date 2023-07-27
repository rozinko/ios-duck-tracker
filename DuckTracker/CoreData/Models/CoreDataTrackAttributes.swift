import Foundation
import MapKit

struct CoreDataTrackAttributes: Codable {
    var minLatitude: CLLocationDegrees?
    var minLongitude: CLLocationDegrees?

    var maxLatitude: CLLocationDegrees?
    var maxLongitude: CLLocationDegrees?

    var minAltitude: CLLocationDistance?
    var maxAltitude: CLLocationDistance?

    var upHill: CLLocationDistance?
    var downHill: CLLocationDistance?

}
