import SwiftUI
import Charts

struct HistoryTrackInfoChartAltitudeView: View {

    let points: [InfoTrackPoint]

    @Binding var selectedPoint: Int?

    let title: String = (".altitude".localized() + " (" + ".meters".localized() + ")").uppercased()

    var altitudeRange: ClosedRange<Int> {
        let minValue = points.reduce(points.first?.altitude ?? 0, { $0 < $1.altitude ? $0 : $1.altitude })
        let maxValue = points.reduce(points.first?.altitude ?? 0, { $0 > $1.altitude ? $0 : $1.altitude })
        let range = max(maxValue - minValue, 250)
        let from = Int(minValue - range * 0.1)
        let till = Int(maxValue + range * 0.1)
        return ClosedRange(uncheckedBounds: (lower: from, upper: till))
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
                .background(Color.commonGreen)
                 */

                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    ForEach(points) {
                        LineMark(
                            x: .value(".time".localized(), $0.timestamp),
                            y: .value(".altitude".localized(), $0.altitude)
                        )
                        .interpolationMethod(.catmullRom)
                        .mask { RectangleMark() }
                        .foregroundStyle(Color.commonGreen)
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
                        .foregroundStyle(Color.commonGreen)
                        .opacity(0.5)
                        .annotation(position: annotationPosition, spacing: 0) {
                            VStack {
                                Text(points[selectedPoint!].timestamp.toString(dateFormat: "HH:mm:ss"))
                                    .padding([.leading, .trailing], 3)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.commonWhite)
                                    .background(Color.commonGreen)
                                    .clipShape(Rectangle())
                            }
                            .padding(.top, 3)
                        }

                        PointMark(
                            x: .value(".time".localized(), points[selectedPoint!].timestamp),
                            y: .value(".altitude".localized(), points[selectedPoint!].altitude)
                        )
                        .foregroundStyle(Color.commonGreen)
                        .annotation(position: annotationPosition, spacing: 2) {
                            Text(points[selectedPoint!].altitude.toStringInt())
                                .font(.system(size: 10, weight: .bold))
                                .padding(3)
                                .foregroundStyle(Color.commonWhite)
                                .background(Color.commonGreen)
                                .clipShape(Capsule())
                        }
                    }
                }
                .chartYScale(domain: altitudeRange)
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
#Preview("Default charts") {
    VStack {
        let previewData = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 9, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 13, speed: 14, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 2, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 2, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 2, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: -4, speed: 11, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 8, speed: 13, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 4, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        Spacer()

        HistoryTrackInfoChartAltitudeView(points: previewData, selectedPoint: .constant(nil))
        HistoryTrackInfoChartAltitudeView(points: previewData, selectedPoint: .constant(0))
        HistoryTrackInfoChartAltitudeView(points: previewData, selectedPoint: .constant(1))
        HistoryTrackInfoChartAltitudeView(points: previewData, selectedPoint: .constant(previewData.count - 2))
        HistoryTrackInfoChartAltitudeView(points: previewData, selectedPoint: .constant(previewData.count - 1))

        Spacer()
    }.background(Color.gray)
}

#Preview("One line") {
    VStack {
        let previewDataOneLine = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 10, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781))
        ]
        let previewDataOneLineHigh = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5000, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5000, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781))
        ]

        Spacer()

        HistoryTrackInfoChartAltitudeView(points: previewDataOneLine, selectedPoint: .constant(nil))
        HistoryTrackInfoChartAltitudeView(points: previewDataOneLine, selectedPoint: .constant(0))
        HistoryTrackInfoChartAltitudeView(points: previewDataOneLine, selectedPoint: .constant(1))
        HistoryTrackInfoChartAltitudeView(points: previewDataOneLineHigh, selectedPoint: .constant(0))
        HistoryTrackInfoChartAltitudeView(points: previewDataOneLineHigh, selectedPoint: .constant(1))

        Spacer()
    }.background(Color.gray)
}

#Preview("High values") {
    VStack {
        let previewDataHighAltitude = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 900, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 1300, speed: 14, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 2, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 2000, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 2, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5500, speed: 11, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 8700, speed: 13, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 14000, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        Spacer()

        HistoryTrackInfoChartAltitudeView(points: previewDataHighAltitude, selectedPoint: .constant(nil))
        HistoryTrackInfoChartAltitudeView(points: previewDataHighAltitude, selectedPoint: .constant(0))
        HistoryTrackInfoChartAltitudeView(points: previewDataHighAltitude, selectedPoint: .constant(1))
        HistoryTrackInfoChartAltitudeView(points: previewDataHighAltitude, selectedPoint: .constant(previewDataHighAltitude.count - 2))
        HistoryTrackInfoChartAltitudeView(points: previewDataHighAltitude, selectedPoint: .constant(previewDataHighAltitude.count - 1))

        Spacer()
    }.background(Color.gray)
}
