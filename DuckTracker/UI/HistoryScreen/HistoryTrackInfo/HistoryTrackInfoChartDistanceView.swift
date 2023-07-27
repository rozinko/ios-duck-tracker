import SwiftUI
import MapKit
import Charts

struct HistoryTrackInfoChartDistanceView: View {

    let points: [InfoTrackPoint]

    let title: String = (".distance".localized() + " (" + ".meters".localized() + ")").uppercased()

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
                        y: .value("Distance", $0.distance)
                    )
                    .interpolationMethod(.catmullRom)
                    .mask { RectangleMark() }
                    .foregroundStyle(Color.commonBlue)
                }
                .frame(height: 120)
            }
            .background(Color.commonElementBackground)
        }
    }
}

struct HistoryTrackInfoChartDistanceView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            HistoryTrackInfoChartDistanceView(points: [
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 5, speed: 10, course: 90,
                               hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 9, speed: 12, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 13, speed: 14, course: 90,
                               hAcc: 3, vAcc: 4, sAcc: 2, distance: 4, timestamp: Date(timeIntervalSince1970: 1685553781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 2, speed: 10, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 7, timestamp: Date(timeIntervalSince1970: 1685554781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: -4, speed: 11, course: 90,
                               hAcc: 3, vAcc: 3, sAcc: 2, distance: 11, timestamp: Date(timeIntervalSince1970: 1685555781)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: -8, speed: 13, course: 90,
                               hAcc: 3, vAcc: 4, sAcc: 2, distance: 12, timestamp: Date(timeIntervalSince1970: 1685555981)),
                InfoTrackPoint(latitude: 0, longitude: 0, altitude: 4, speed: 10, course: 90,
                               hAcc: 3, vAcc: 2, sAcc: 2, distance: 13, timestamp: Date(timeIntervalSince1970: 1685558781))
            ])

            Spacer()
        }.background(Color.gray)
    }
}
