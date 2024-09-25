import SwiftUI
import Charts

struct HistoryTrackInfoChartDistanceView: View {

    let points: [InfoTrackPoint]

    @Binding var selectedPoint: Int?

    let title: String = (".distance".localized() + " (" + ".meters".localized() + ")").uppercased()

    var distanceRange: ClosedRange<Int> {
        let from = 0
        let till = Int(points.last?.distance ?? 0)
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
                .background(Color.commonBlue)
                 */

                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    ForEach(points) {
                        LineMark(
                            x: .value(".time".localized(), $0.timestamp),
                            y: .value(".distance".localized(), $0.distance)
                        )
                        .interpolationMethod(.catmullRom)
                        .mask { RectangleMark() }
                        .foregroundStyle(Color.commonBlue)
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
                        .foregroundStyle(Color.commonBlue)
                        .opacity(0.5)
                        .annotation(position: annotationPosition, spacing: 0) {
                            VStack {
                                Text(points[selectedPoint!].timestamp.toString(dateFormat: "HH:mm:ss"))
                                    .padding([.leading, .trailing], 3)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.commonWhite)
                                    .background(Color.commonBlue)
                                    .clipShape(Rectangle())
                            }
                            .padding(.top, 3)
                        }

                        PointMark(
                            x: .value(".time".localized(), points[selectedPoint!].timestamp),
                            y: .value(".distance".localized(), points[selectedPoint!].distance)
                        )
                        .foregroundStyle(Color.commonBlue)
                        .annotation(position: annotationPosition, spacing: 2) {
                            Text(points[selectedPoint!].distance.toStringInt())
                                .font(.system(size: 10, weight: .bold))
                                .padding(3)
                                .foregroundStyle(Color.commonWhite)
                                .background(Color.commonBlue)
                                .clipShape(Capsule())
                        }
                    }
                }
                .chartYScale(domain: distanceRange)
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
#Preview("Distance charts") {
    VStack {
        let previewData = [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 9, speed: 12, course: 90, hAcc: 3, vAcc: 5, sAcc: 4, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 13, speed: 14, course: 90, hAcc: 3, vAcc: 5, sAcc: 6, distance: 5, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 2, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 5, distance: 8, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: -4, speed: 11, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 11, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 8, speed: 13, course: 90, hAcc: 3, vAcc: 5, sAcc: 1, distance: 12, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 4, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 3, distance: 14, timestamp: Date(timeIntervalSince1970: 1685558781))
        ]

        Spacer()

        HistoryTrackInfoChartDistanceView(points: previewData, selectedPoint: .constant(nil))
        HistoryTrackInfoChartDistanceView(points: previewData, selectedPoint: .constant(0))
        HistoryTrackInfoChartDistanceView(points: previewData, selectedPoint: .constant(1))
        HistoryTrackInfoChartDistanceView(points: previewData, selectedPoint: .constant(previewData.count - 2))
        HistoryTrackInfoChartDistanceView(points: previewData, selectedPoint: .constant(previewData.count - 1))

        Spacer()
    }.background(Color.gray)
}
