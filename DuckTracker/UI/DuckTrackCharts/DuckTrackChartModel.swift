import SwiftUI

struct DuckTrackChartModel: Equatable {
    let data: [DuckTrackChartPoint]?
    let avgSpeed: Double

    let speedColor: Color = .commonOrange
    let altitudeColor: Color = .commonGreen
    let distanceColor: Color = .commonBlue

    let speedTitle = ".speed"
    let altitudeTitle = ".altitude"
    let distanceTitle = ".distance"

    let avgSpeedTitle = ".avgSpeed"

    let speedUnit = ".kmh"
    let altitudeUnit = ".meters"
    let distanceUnit: String

    var speedDataRange: ClosedRange<Double> { calcRange(for: .speed, withData: self.data) }
    var altitudeDataRange: ClosedRange<Double> { calcRange(for: .altitude, withData: self.data) }
    var distanceDataRange: ClosedRange<Double> { calcRange(for: .distance, withData: self.data) }

    private func calcRange(for visible: DuckTrackChartVisible, withData dt: [DuckTrackChartPoint]?) -> ClosedRange<Double> {
        var min: Double = (visible == .speed ? dt?.first?.speed : (visible == .altitude ? dt?.first?.altitude : dt?.first?.distance)) ?? 0.0
        var max: Double = min

        for point in dt ?? [] {
            if (visible == .speed ? point.speed : (visible == .altitude ? point.altitude : point.distance)) < min { min = (visible == .speed ? point.speed : (visible == .altitude ? point.altitude : point.distance)) }
            if (visible == .speed ? point.speed : (visible == .altitude ? point.altitude : point.distance)) > max { max = (visible == .speed ? point.speed : (visible == .altitude ? point.altitude : point.distance)) }
        }

        let range = max - min
        let from = Double(min - range * 0.1)
        let till = Double(max + range * 0.1)

        let onlyPositive = visible == .speed || visible == .distance

        return ClosedRange(uncheckedBounds: (lower: onlyPositive && from < 0 ? 0 : from, upper: till))
    }

    init(data: [DuckTrackChartPoint]?, avgSpeed: Double) {
        var dt = data
        let maxDistance = data?.last?.distance ?? 0

        if maxDistance >= 1000 {
            // change speed m/s to km/h and distance m to km
            dt = dt?.map { DuckTrackChartPoint(speed: $0.speed.toKmh(), altitude: $0.altitude, distance: $0.distance.toKm(), date: $0.date) }
            self.distanceUnit = ".km"
        } else {
            // change speed m/s to km/h only
            dt = dt?.map { DuckTrackChartPoint(speed: $0.speed.toKmh(), altitude: $0.altitude, distance: $0.distance, date: $0.date) }
            self.distanceUnit = ".meters"
        }
        self.data = dt

        // change average speed m/s to km/h
        self.avgSpeed = avgSpeed.toKmh()
    }
}
