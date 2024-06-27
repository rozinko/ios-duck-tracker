import Foundation
import MapKit

public struct InfoTrack: Identifiable {
    public let id: UUID

    let cdTrack: CoreDataTrack?

    let timestampStart: Date
    let timestampFinish: Date
    let timestampUpdate: Date

    let trackId: String
    let uniqueHash: String

    let gpxFileName: String
    let gpxFileURL: URL

    var title: String
    var type: ActiveTrackType

    let distance: CLLocationDistance
    let maxSpeed: CLLocationSpeed
    let avgSpeed: CLLocationSpeed

    var attributes: CoreDataTrackAttributes
    let route: InfoTrackRoute

    init(fromCoreDataTrack cdTrack: CoreDataTrack) {
        self.cdTrack = cdTrack

        self.id = cdTrack.id!

        self.timestampStart = cdTrack.timestampStart!
        self.timestampFinish = cdTrack.timestampFinish!
        self.timestampUpdate = cdTrack.timestampUpdate!

        self.trackId = cdTrack.trackId!
        self.uniqueHash = cdTrack.uniqueHash!

        // gpxFileName and gpxFileURL
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.dateFormat = "yyyyMMdd-HHmmss"

        self.gpxFileName = "DuckTrack-" + RFC3339DateFormatter.string(from: timestampStart) + "-" + uniqueHash + ".gpx"
        self.gpxFileURL = DuckFileManager.gpxFolderURL.appendingPathComponent(self.gpxFileName)

        self.title = cdTrack.title!
        self.type = ActiveTrackType(rawValue: cdTrack.type!) ?? .other

        self.distance = cdTrack.distance
        self.maxSpeed = cdTrack.maxSpeed
        self.avgSpeed = cdTrack.avgSpeed

        self.attributes = cdTrack.decodeJSONAttributes() ?? CoreDataTrackAttributes()
        self.route = InfoTrackRoute(fromCoreDataTrackRoute: cdTrack.decodeJSONRoute())
    }

}

extension InfoTrack {

    var timeIntervalString: String {
        let formatter = DateIntervalFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: timestampStart, to: timestampFinish)
    }

    var timeInSeconds: Double { timestampFinish.timeIntervalSince1970 - timestampStart.timeIntervalSince1970 }
    var paceInSeconds: Double { timeInSeconds / distance.toKm() }

    var minLatitude: CLLocationDegrees { return self.attributes.minLatitude ?? self.route.minLatitude }
    var minLongitude: CLLocationDegrees { return self.attributes.minLongitude ?? self.route.minLongitude }

    var maxLatitude: CLLocationDegrees { return self.attributes.maxLatitude ?? self.route.maxLatitude }
    var maxLongitude: CLLocationDegrees { return self.attributes.maxLongitude ?? self.route.maxLongitude }

    var centerLatitude: CLLocationDegrees { return (minLatitude + maxLatitude) / 2 }
    var centerLongitude: CLLocationDegrees { return (minLongitude + maxLongitude) / 2 }

    var latitudeDelta: Double {
        let delta = abs(maxLatitude - minLatitude)
        return delta <= 0 ? 0.03 : delta * 1.15
    }
    var longitudeDelta: Double {
        let delta = abs(maxLongitude - minLongitude)
        return delta <= 0 ? 0.03 : delta * 1.15
    }

    var minAltitude: CLLocationDistance { return self.attributes.minAltitude ?? self.route.minAltitude }
    var maxAltitude: CLLocationDistance { return self.attributes.maxAltitude ?? self.route.maxAltitude }

    var downHill: CLLocationDistance { return self.attributes.downHill ?? self.route.downHill }
    var upHill: CLLocationDistance { return self.attributes.upHill ?? self.route.upHill }

    func getTimeAsString() -> String {
        var sec = Int(timeInSeconds)
        var min = 0
        var hrs = 0

        while sec >= 3600 {
            sec -= 3600
            hrs += 1
        }

        while sec >= 60 {
            sec -= 60
            min += 1
        }

        return (hrs < 10 ? "0" : "") + String(hrs) + ":" + (min < 10 ? "0" : "") + String(min) + ":" + (sec < 10 ? "0" : "") + String(sec)
    }

    func getPaceAsString() -> String {
        var sec = Int(paceInSeconds)
        var min = 0

        while sec >= 60 {
            sec -= 60
            min += 1
        }

        return (min < 10 ? "0" : "") + String(min) + ":" + (sec < 10 ? "0" : "") + String(sec)
    }

}
