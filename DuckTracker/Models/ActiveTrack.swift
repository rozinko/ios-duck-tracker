import Foundation
import MapKit

public struct ActiveTrack: Identifiable {
    public let id = UUID()

    var trackPoints: [TrackPoint] = []

    var trackCoordinates: [CLLocationCoordinate2D] { trackPoints.map {$0.coordinate} }

    var timeFromStart: Double {
        if trackPoints.count == 0 {
            return 0
        }
        return Date().timeIntervalSince1970 - trackPoints.first!.location.timestamp.timeIntervalSince1970
    }

    var time: Double {
        if trackPoints.count <= 1 {
            return 0
        }
        return trackPoints.last!.location.timestamp.timeIntervalSince1970 - trackPoints.first!.location.timestamp.timeIntervalSince1970
    }

    var distance: CLLocationDistance {
        trackPoints.reduce(0, {$0 + ($1.distance != nil ? $1.distance! : 0)})
    }

    var maxSpeed: CLLocationSpeed {
        trackPoints.reduce(0, {$0 > $1.location.speed ? $0 : $1.location.speed})
    }

    var avgSpeed: CLLocationSpeed {
        trackPoints.count <= 1 ? maxSpeed : distance / time
    }

    func getTimeString(isRecording: Bool) -> String {
        var sec = Int(isRecording ? timeFromStart : time)
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

    func getPaceAsString(isRecording: Bool) -> String {
        var sec = distance > 0 ? Int((isRecording ? timeFromStart : time) / distance.toKm()) : 0 // pace in seconds
        var min = 0

        while sec >= 60 {
            sec -= 60
            min += 1
        }

        return (min < 10 ? "0" : "") + String(min) + ":" + (sec < 10 ? "0" : "") + String(sec)
    }

}
