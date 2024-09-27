import SwiftUI
import MapKit
import Charts

struct HistoryTrackInfoChartsView: View {

    let points: [InfoTrackPoint]
    let avgSpeed: CLLocationSpeed

    @Binding var selectedPoint: Int?

    var body: some View {
        if #available(iOS 16.0, *) {
            if !points.isEmpty {
                VStack(spacing: 1) {
                    HistoryTrackInfoChartSpeedView(points: points, avgSpeed: avgSpeed, selectedPoint: $selectedPoint)
                        .padding([.top, .bottom], 5)
                        .padding([.leading, .trailing], 8)
                        .background(Color.commonElementBackground)

                    HistoryTrackInfoChartAltitudeView(points: points, selectedPoint: $selectedPoint)
                        .padding([.top, .bottom], 5)
                        .padding([.leading, .trailing], 8)
                        .background(Color.commonElementBackground)

                    HistoryTrackInfoChartDistanceView(points: points, selectedPoint: $selectedPoint)
                        .padding([.top, .bottom], 5)
                        .padding([.leading, .trailing], 8)
                        .background(Color.commonElementBackground)
                }
            } else {
                HStack {
                    Spacer()
                    Text("HistoryTrackInfoChartsView.noData")
                        .font(Font.caption.bold())
                        .multilineTextAlignment(.center)
                        .padding(30)
                    Spacer()
                }
                .background(Color.commonElementBackground)
            }
        } else {
            HStack {
                Spacer()
                Text("HistoryTrackInfoChartsView.ios16")
                    .font(Font.caption.bold())
                    .multilineTextAlignment(.center)
                    .padding(30)
                Spacer()
            }
            .background(Color.commonElementBackground)
        }
    }
}

// swiftlint:disable line_length
#Preview("Charts") {
    VStack {
        Spacer()
        HistoryTrackInfoChartsView(points: [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 22, speed: 10, course: 90, hAcc: 3, vAcc: 5, sAcc: 2, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 25, speed: 12, course: 90, hAcc: 3, vAcc: 7, sAcc: 2, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 27, speed: 14, course: 90, hAcc: 3, vAcc: 2, sAcc: 2, distance: 4, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 26, speed: 10, course: 90, hAcc: 3, vAcc: 1, sAcc: 2, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 23, speed: 11, course: 90, hAcc: 3, vAcc: 3, sAcc: 2, distance: 9, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 22, speed: 13, course: 90, hAcc: 3, vAcc: 4, sAcc: 2, distance: 11, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 24, speed: 10, course: 90, hAcc: 3, vAcc: 2, sAcc: 2, distance: 12, timestamp: Date(timeIntervalSince1970: 1685558781))
        ], avgSpeed: 42, selectedPoint: .constant(1))
        Spacer()
    }.background(Color.commonBackground)
}

#Preview("Empty data") {
    VStack {
        Spacer()
        HistoryTrackInfoChartsView(points: [], avgSpeed: 0, selectedPoint: .constant(nil))
        Spacer()
    }.background(Color.commonBackground)
}
