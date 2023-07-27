import MapKit

struct CoreDataTrackPoint: Codable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees

    var altitude: CLLocationDistance
    var speed: CLLocationSpeed
    var course: CLLocationDirection

    var hAcc: CLLocationAccuracy
    var vAcc: CLLocationAccuracy
    var sAcc: CLLocationSpeedAccuracy

    var timestamp: Date

    init(
        latitude: CLLocationDegrees, longitude: CLLocationDegrees,
        altitude: CLLocationDistance, speed: CLLocationSpeed, course: CLLocationDirection,
        hAcc: CLLocationAccuracy, vAcc: CLLocationAccuracy, sAcc: CLLocationSpeedAccuracy,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.course = course
        self.hAcc = hAcc
        self.vAcc = vAcc
        self.sAcc = sAcc
        self.timestamp = timestamp
    }

    init(fromLocation location: CLLocation) {
        self.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            speed: location.speed,
            course: location.course,
            hAcc: location.horizontalAccuracy,
            vAcc: location.verticalAccuracy,
            sAcc: location.speedAccuracy,
            timestamp: location.timestamp)
    }
}
