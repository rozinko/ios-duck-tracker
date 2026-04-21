import SwiftUI
import MapKit

struct DuckTrackChartPoint: Equatable {
    let speed: CLLocationSpeed
    let altitude: Double
    let distance: CLLocationDistance
    let date: Date
}
