import MapKit

public struct ShortTrack: Identifiable {
    public let id: UUID

    var title: String
    var type: ActiveTrackType

    let timestampStart: Date
    let timestampFinish: Date

    let distance: CLLocationDistance
    let maxSpeed: CLLocationSpeed
    let avgSpeed: CLLocationSpeed

    var attributes: CoreDataTrackAttributes

    init(fromCoreDataTrack cdTrack: CoreDataTrack) {
        self.id = cdTrack.id!

        self.title = cdTrack.title!
        self.type = ActiveTrackType(rawValue: cdTrack.type!) ?? .other

        self.timestampStart = cdTrack.timestampStart!
        self.timestampFinish = cdTrack.timestampFinish!

        self.distance = cdTrack.distance
        self.maxSpeed = cdTrack.maxSpeed
        self.avgSpeed = cdTrack.avgSpeed

        self.attributes = cdTrack.decodeJSONAttributes() ?? CoreDataTrackAttributes()
    }

}

extension ShortTrack {

    var timeIntervalString: String {
        let formatter = DateIntervalFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: timestampStart, to: timestampFinish)
    }

    var timeInSeconds: Double { timestampFinish.timeIntervalSince1970 - timestampStart.timeIntervalSince1970 }
    var paceInSeconds: Double { timeInSeconds / distance.toKm() }

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
