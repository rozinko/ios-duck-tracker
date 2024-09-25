import SwiftUI
import MapKit
import Charts

struct HistoryTrackInfoChartSpeedView: View {

    let points: [InfoTrackPoint]
    let avgSpeed: CLLocationSpeed

    @Binding var selectedPoint: Int?

    let title: String = (".speed".localized() + " (" + ".kmh".localized() + ")").uppercased()

    var speedRange: ClosedRange<Int> {
        let minValue = points.reduce(points.first?.speed ?? 0, { $0 < $1.speed ? $0 : $1.speed }).toKmh()
        let maxValue = points.reduce(points.first?.speed ?? 0, { $0 > $1.speed ? $0 : $1.speed }).toKmh()
        let range = max(maxValue - minValue, 10)
        let from = Int(minValue - range * 0.2)
        let till = Int(maxValue + range * 0.2)
        return ClosedRange(uncheckedBounds: (lower: from < 0 ? 0 : from, upper: till))
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 0) {
                // TODO: waiting v2.0
                /*
                HStack {
                    Spacer()
                    Text(title)
                        .font(Font.caption.weight(.bold))
                        .foregroundColor(Color.commonWhite)
                    Spacer()
                }
                .padding(2)
                .background(Color.commonOrange)
                 */

                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    RuleMark(y: .value(".avgspeed".localized(), avgSpeed.toKmh()))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                        .foregroundStyle(Color.commonOrange)
                        .opacity(0.5)

                    ForEach(points) {
                        LineMark(
                            x: .value(".time".localized(), $0.timestamp),
                            y: .value(".speed".localized(), $0.speed.toKmh())
                        )
                        .interpolationMethod(.catmullRom)
                        .mask { RectangleMark() }
                        .foregroundStyle(Color.commonOrange)
                    }

                    if selectedPoint != nil && selectedPoint! < points.count {
                        var annotationPosition: AnnotationPosition {
                            if selectedPoint! <= points.count / 5 {
                                return .bottomTrailing
                            }
                            if selectedPoint! >= points.count * 4 / 5 {
                                return .bottomLeading
                            }
                            return .bottom
                        }

                        RuleMark(
                            x: .value(".time".localized(), points[selectedPoint!].timestamp)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.commonOrange)
                        .opacity(0.5)
                        .annotation(position: annotationPosition, spacing: 0) {
                            VStack {
                                Text(points[selectedPoint!].timestamp.toString(dateFormat: "HH:mm:ss"))
                                    .padding([.leading, .trailing], 3)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.commonWhite)
                                    .background(Color.commonOrange)
                                    .clipShape(Rectangle())
                            }
                            .padding(.top, 3)
                        }

                        PointMark(
                            x: .value(".time".localized(), points[selectedPoint!].timestamp),
                            y: .value(".speed".localized(), points[selectedPoint!].speed.toKmh())
                        )
                        .foregroundStyle(Color.commonOrange)
                        .annotation(position: annotationPosition, spacing: 2) {
                            Text(points[selectedPoint!].speed.toKmh().toStringInt())
                                .font(.system(size: 10, weight: .bold))
                                .padding(3)
                                .foregroundStyle(Color.commonWhite)
                                .background(Color.commonOrange)
                                .clipShape(Capsule())
                        }
                    }
                }
                .chartYScale(domain: speedRange)
                .frame(height: 120)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = CGPoint(
                                            x: value.location.x - geometry[proxy.plotAreaFrame].origin.x,
                                            y: value.location.y - geometry[proxy.plotAreaFrame].origin.y
                                        )
                                        let (gestureTimestamp, _) = proxy.value(at: location, as: (Date, Double).self) ?? (nil, nil)

                                        var closestPoint = 0
                                        var closestTimeinterval = abs(gestureTimestamp!.timeIntervalSince1970 - points[0].timestamp.timeIntervalSince1970)

                                        var i = 1
                                        while i < points.count {
                                            let pointTimeInterval = abs(gestureTimestamp!.timeIntervalSince1970 - points[i].timestamp.timeIntervalSince1970)
                                            if pointTimeInterval <= closestTimeinterval {
                                                closestPoint = i
                                                closestTimeinterval = pointTimeInterval
                                                i += 1
                                            } else {
                                                i = points.count
                                            }
                                        }

                                        selectedPoint = closestPoint
                                    }
                                    .onEnded { _ in
                                        selectedPoint = nil
                                    }
                            )
                    }
                }
            }
            .background(Color.commonElementBackground)
        }
    }
}

// swiftlint:disable line_length
#Preview("Speed charts") {
    VStack {
        let previewData = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 14, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 5, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 30, speed: 11, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 8, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 25, speed: 13, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 10, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 12, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        Spacer()

        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(nil))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(0))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(1))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(previewData.count - 2))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(previewData.count - 1))

        Spacer()
    }.background(Color.gray)
}

#Preview("Small range") {
    VStack {
        let previewData = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 42, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 5, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 30, speed: 42, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 8, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 25, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 10, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 42, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 12, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        let previewDataOneLine = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 5, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 41, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781))
        ]

        Spacer()

        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(nil))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(0))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(1))
        HistoryTrackInfoChartSpeedView(points: previewDataOneLine, avgSpeed: 11.5, selectedPoint: .constant(previewDataOneLine.count - 2))
        HistoryTrackInfoChartSpeedView(points: previewDataOneLine, avgSpeed: 11.5, selectedPoint: .constant(previewDataOneLine.count - 1))

        Spacer()
    }.background(Color.gray)
}

#Preview("High speed") {
    VStack {
        let previewData = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 100, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 115, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 110, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 5, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 15, speed: 125, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 30, speed: 110, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 8, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 25, speed: 120, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 10, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 20, speed: 118, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 12, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        Spacer()

        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(nil))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(0))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(1))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(previewData.count - 2))
        HistoryTrackInfoChartSpeedView(points: previewData, avgSpeed: 11.5, selectedPoint: .constant(previewData.count - 1))

        Spacer()
    }.background(Color.gray)
}
