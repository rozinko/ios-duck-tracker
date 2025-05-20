import ActivityKit
import CoreLocation

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isRecording: Bool
        var trackType: ActiveTrackType
        var distance: CLLocationDistance
        var lastDate: Date
    }

    var startDate: Date
}
