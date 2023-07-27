import MapKit

struct HistoryStatsBlockItem: Identifiable {
    let id: UUID = UUID()

    var type: ActiveTrackType
    var distance: CLLocationDistance
    var timeInSeconds: Int
}
