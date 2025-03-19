import SwiftUI
import Charts

struct HistoryTrackInfoChartsView: View {

    @Binding var selectedPoint: Int?

    let points: [InfoTrackPoint]?
    let avgSpeed: Double

    var chartDataSpeed: [ChartPoint]? { points?.map { ChartPoint(date: $0.timestamp, value: $0.speed.toKmh())} }
    var chartDataAltitude: [ChartPoint]? { points?.map { ChartPoint(date: $0.timestamp, value: $0.altitude)} }
    var chartDataDistance: [ChartPoint]? { points?.map { ChartPoint(date: $0.timestamp, value: $0.distance)} }

    let titleSpeed: String = (".speed".localized() + " (" + ".kmh".localized() + ")").uppercased()
    let titleAltitude: String = (".altitude".localized() + " (" + ".meters".localized() + ")").uppercased()
    let titleDistance: String = (".distance".localized() + " (" + ".meters".localized() + ")").uppercased()

    var body: some View {
        if #unavailable(iOS 16.0) {
            // ios < 16.0
            HStack {
                Spacer()
                Text("HistoryTrackInfoChartsView.ios16")
                    .font(Font.caption.bold())
                    .multilineTextAlignment(.center)
                    .padding(30)
                Spacer()
            }
            .background(Color.commonElementBackground)
        } else if points == nil {
            // loading data
            VStack {
                Spacer(minLength: 30)
                LoadingView(withSize: .small)
                Spacer(minLength: 30)
            }
            .background(Color.commonElementBackground)
        } else if points!.isEmpty {
            // empty data
            HStack {
                Spacer()
                Text("HistoryTrackInfoChartsView.noData")
                    .font(Font.caption.bold())
                    .multilineTextAlignment(.center)
                    .padding(30)
                Spacer()
            }
            .background(Color.commonElementBackground)
        } else {
            LazyVStack(spacing: 1) {
                HistoryTrackInfoChartView(
                    selectedPoint: $selectedPoint,
                    title: titleSpeed,
                    data: chartDataSpeed,
                    color: Color.commonOrange,
                    onlyPositive: true,
                    avg: avgSpeed,
                    avgTitle: ".avgspeed".localized()
                )
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 8)
                .background(Color.commonElementBackground)

                HistoryTrackInfoChartView(
                    selectedPoint: $selectedPoint,
                    title: titleAltitude,
                    data: chartDataAltitude,
                    color: Color.commonGreen,
                    onlyPositive: false
                )
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 8)
                .background(Color.commonElementBackground)

                HistoryTrackInfoChartView(
                    selectedPoint: $selectedPoint,
                    title: titleDistance,
                    data: chartDataDistance,
                    color: Color.commonBlue,
                    onlyPositive: true
                )
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 8)
                .background(Color.commonElementBackground)
            }
        }
    }
}

#Preview("Data") {
    VStack {
        Spacer()
        HistoryTrackInfoChartsView(selectedPoint: .constant(nil), points: [
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 22, speed: 10, distance: 2, timestamp: Date(timeIntervalSince1970: 1685551781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 25, speed: 12, distance: 3, timestamp: Date(timeIntervalSince1970: 1685552781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 27, speed: 14, distance: 4, timestamp: Date(timeIntervalSince1970: 1685553781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 26, speed: 10, distance: 6, timestamp: Date(timeIntervalSince1970: 1685554781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 23, speed: 11, distance: 9, timestamp: Date(timeIntervalSince1970: 1685555781)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 22, speed: 13, distance: 11, timestamp: Date(timeIntervalSince1970: 1685555981)),
            InfoTrackPoint(latitude: 0, longitude: 0, altitude: 24, speed: 10, distance: 12, timestamp: Date(timeIntervalSince1970: 1685558781))
        ], avgSpeed: 42)
        Spacer()
    }.background(Color.commonBackground)
}

#Preview("No data") {
    VStack {
        Spacer()
        HistoryTrackInfoChartsView(selectedPoint: .constant(nil), points: [], avgSpeed: 0)
        Spacer()
    }.background(Color.commonBackground)
}

#Preview("Loading") {
    VStack {
        Spacer()
        HistoryTrackInfoChartsView(selectedPoint: .constant(nil), points: nil, avgSpeed: 0)
        Spacer()
    }.background(Color.commonBackground)
}
