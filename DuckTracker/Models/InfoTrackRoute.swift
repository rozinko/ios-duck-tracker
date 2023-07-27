import Foundation
import MapKit

struct InfoTrackRoute {

    var points: [InfoTrackPoint] = []

    init(fromCoreDataTrackRoute cdTrackRoute: CoreDataTrackRoute?) {
        if cdTrackRoute != nil && !cdTrackRoute!.points.isEmpty {
            var distance: CLLocationDistance = 0
            var location = CLLocation(latitude: cdTrackRoute!.points.first!.latitude, longitude: cdTrackRoute!.points.first!.longitude)

            for point in cdTrackRoute!.points {
                let nextLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
                distance += nextLocation.distance(from: location)
                location = nextLocation

                self.points.append(InfoTrackPoint(
                    latitude: point.latitude,
                    longitude: point.longitude,
                    altitude: point.altitude,
                    speed: point.speed,
                    course: point.course,
                    hAcc: point.hAcc,
                    vAcc: point.vAcc,
                    sAcc: point.sAcc,
                    distance: distance,
                    timestamp: point.timestamp))
            }
        }
    }

}

// coordinate extensions
extension InfoTrackRoute {

    var coordinates: [CLLocationCoordinate2D] {
        self.points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    var minLatitude: CLLocationDegrees {
        return self.points.reduce(self.points.first?.latitude ?? 59.939) { $0 < $1.latitude ? $0 : $1.latitude }
    }

    var minLongitude: CLLocationDegrees {
        return self.points.reduce(self.points.first?.longitude ?? 30.315) { $0 < $1.longitude ? $0 : $1.longitude }
    }

    var maxLatitude: CLLocationDegrees {
        return self.points.reduce(self.points.first?.latitude ?? 59.939) { $0 > $1.latitude ? $0 : $1.latitude }
    }

    var maxLongitude: CLLocationDegrees {
        return self.points.reduce(self.points.first?.longitude ?? 30.315) { $0 > $1.longitude ? $0 : $1.longitude }
    }

}

// altitude extensions
extension InfoTrackRoute {

    var minAltitude: CLLocationDistance {
        return self.points.reduce(self.points.first?.altitude ?? 0) { $0 < $1.altitude ? $0 : $1.altitude }
    }

    var maxAltitude: CLLocationDistance {
        return self.points.reduce(self.points.first?.altitude ?? 0) { $0 > $1.altitude ? $0 : $1.altitude }
    }

    var upHill: CLLocationDistance {
        var up: CLLocationDistance = 0
        var prev: CLLocationDistance = self.points.first?.altitude ?? 0

        for point in self.points {
            if point.altitude > prev {
                up += point.altitude - prev
            }
            prev = point.altitude
        }

        return up
    }

    var downHill: CLLocationDistance {
        var down: CLLocationDistance = 0
        var prev: CLLocationDistance = self.points.first?.altitude ?? 0

        for point in self.points {
            if point.altitude < prev {
                down += prev - point.altitude
            }
            prev = point.altitude
        }

        return down
    }

}

// speed extensions
extension InfoTrackRoute {

    var minSpeed: CLLocationSpeed {
        return self.points.reduce(self.points.first?.speed ?? 0) { $0 < $1.speed ? $0 : $1.speed }
    }

    var maxSpeed: CLLocationSpeed {
        return self.points.reduce(self.points.first?.speed ?? 0) { $0 > $1.speed ? $0 : $1.speed }
    }

}
