import SwiftUI
import MapKit
import Charts

struct HistoryTrackInfoChartAltitudeView: View {

    let points: [InfoTrackPoint]

    let title: String = (".altitude".localized() + " (" + ".meters".localized() + ")").uppercased()

    var altitudeRange: ClosedRange<Int> {
        let min = points.reduce(points.first?.altitude ?? 0, { $0 < $1.altitude ? $0 : $1.altitude })
        let max = points.reduce(points.first?.altitude ?? 0, { $0 > $1.altitude ? $0 : $1.altitude })
//        let min = points.reduce(points.first?.altitude ?? 0, { $0 < $1.altitude-$1.vAcc ? $0 : $1.altitude-$1.vAcc })
//        let max = points.reduce(points.first?.altitude ?? 0, { $0 > $1.altitude+$1.vAcc ? $0 : $1.altitude+$1.vAcc })
        let range = max - min
        let from = Int(min - range * 0.1)
        let till = Int(max + range * 0.1)
        return ClosedRange(uncheckedBounds: (lower: from, upper: till))
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart(points) {
                    LineMark(
                        x: .value("Time", $0.timestamp),
                        y: .value("Altitude", $0.altitude)
                    )
                    .interpolationMethod(.catmullRom)
                    .mask { RectangleMark() }
                    .foregroundStyle(Color.commonGreen)

//                    AreaMark(
//                            x: .value("Time", $0.timestamp),
//                            yStart: .value("Min Altitude", $0.altitude - $0.vAcc),
//                            yEnd: .value("Max Altitude", $0.altitude + $0.vAcc)
//                        )
//                    .opacity(0.15)
//                    .interpolationMethod(.catmullRom)
//                    .mask { RectangleMark() }
//                    .foregroundStyle(Color.commonGreen)
                }
                .chartYScale(domain: altitudeRange)
                .frame(height: 120)
            }
            .background(Color.commonElementBackground)
        }
    }
}

struct HistoryTrackInfoChartAltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            HistoryTrackInfoChartAltitudeView(points: [
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5, speed: 10, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 9, speed: 12, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685552781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 13, speed: 14, course: 90,
                               hAcc: 3, vAcc: 4, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685553781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 2, speed: 10, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685554781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: -4, speed: 11, course: 90,
                               hAcc: 3, vAcc: 3, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: -8, speed: 13, course: 90,
                               hAcc: 3, vAcc: 4, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685555981)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 4, speed: 10, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685558781))
            ])

            Spacer()
        }.background(Color.gray)
    }
}
