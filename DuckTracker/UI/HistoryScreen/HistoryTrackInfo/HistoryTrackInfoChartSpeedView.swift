import SwiftUI
import MapKit
import Charts

struct HistoryTrackInfoChartSpeedView: View {

    let points: [InfoTrackPoint]
    let avgSpeed: CLLocationSpeed

    let title: String = (".speed".localized() + " (" + ".kmh".localized() + ")").uppercased()

    var speedRange: ClosedRange<Int> {
        let min = points.reduce(points.first?.speed ?? 0, { $0 < $1.speed ? $0 : $1.speed }).toKmh()
        let max = points.reduce(points.first?.speed ?? 0, { $0 > $1.speed ? $0 : $1.speed }).toKmh()
//        let min = points.reduce(points.first?.speed ?? 0, { $0 < $1.speed-$1.sAcc ? $0 : $1.speed-$1.sAcc }).toKmh()
//        let max = points.reduce(points.first?.speed ?? 0, { $0 > $1.speed+$1.sAcc ? $0 : $1.speed+$1.sAcc }).toKmh()
        let range = max - min
        let from = Int(min - range * 0.1)
        let till = Int(max + range * 0.1)
        return ClosedRange(uncheckedBounds: (lower: from < 0 ? 0 : from, upper: till))
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    ForEach(points) {
                        RuleMark(y: .value(".avgspeed".localized(), avgSpeed.toKmh()))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                            .foregroundStyle(Color.commonOrange)
                            .opacity(0.15)

                        LineMark(
                            x: .value(".time".localized(), $0.timestamp),
                            y: .value(".speed".localized(), $0.speed.toKmh())
                        )
                        .interpolationMethod(.catmullRom)
                        .mask { RectangleMark() }
                        .foregroundStyle(Color.commonOrange)

//                        AreaMark(
//                                x: .value("Time", $0.timestamp),
//                                yStart: .value("Min Speed", $0.speed.toKmh() - $0.sAcc.toKmh()),
//                                yEnd: .value("Max Speed", $0.speed.toKmh() + $0.sAcc.toKmh())
//                            )
//                        .opacity(0.15)
//                        .interpolationMethod(.catmullRom)
//                        .mask { RectangleMark() }
//                        .foregroundStyle(Color.commonOrange)
                    }
                }
                .chartYScale(domain: speedRange)
                .frame(height: 120)
            }
            .background(Color.commonElementBackground)
        }
    }
}

struct HistoryTrackInfoChartSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            HistoryTrackInfoChartSpeedView(points: [
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 10, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 12, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 4, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 14, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 6, distance: 2, timestamp: Date(timeIntervalSince1970: 1685553781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 10, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 5, distance: 2, timestamp: Date(timeIntervalSince1970: 1685554781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 11, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 13, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 1, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555981)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 0, speed: 10, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 3, distance: 2, timestamp: Date(timeIntervalSince1970: 1685558781))
            ], avgSpeed: 7)

            Spacer()
        }.background(Color.gray)
    }
}
