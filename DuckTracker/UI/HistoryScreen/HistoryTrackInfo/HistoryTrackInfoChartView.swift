import SwiftUI
import Charts

struct ChartPoint: Hashable {
    let date: Date
    let value: Double
}

struct HistoryTrackInfoChartView: View {

    let title: String

    let data: [ChartPoint]?
    let color: Color
    let onlyPositive: Bool

    let avg: Double?
    let avgTitle: String?

    init(title: String, data: [ChartPoint]?, color: Color, onlyPositive: Bool, avg: Double?, avgTitle: String?) {
        self.title = title
        self.onlyPositive = onlyPositive
        self.data = data
        self.color = color
        self.avg = avg
        self.avgTitle = avgTitle
    }

    init(title: String, data: [ChartPoint]?, color: Color, onlyPositive: Bool) {
        self.init(title: title, data: data, color: color, onlyPositive: onlyPositive, avg: nil, avgTitle: nil)
    }

    var dataRange: ClosedRange<Double> {
        var min: Double = data?.first?.value ?? 0.0
        var max: Double = min
        for point in data ?? [] {
            if point.value < min { min = point.value }
            if point.value > max { max = point.value }
        }
        let range = max - min
        let from = Double(min - range * 0.1)
        let till = Double(max + range * 0.1)
        return ClosedRange(uncheckedBounds: (lower: onlyPositive && from < 0 ? 0 : from, upper: till))
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    if data != nil {
                        // main data
                        if #available(iOS 18.0, *) {
                            LinePlot(
                                data!,
                                x: .value(".time".localized(), \.date),
                                y: .value(".speed".localized(), \.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(color)
                        } else {
                            ForEach(data!, id: \.date) { point in
                                LineMark(
                                    x: .value(".time".localized(), point.date),
                                    y: .value(".speed".localized(), point.value)
                                )
                                .interpolationMethod(.catmullRom)
                                .mask { RectangleMark() }
                                .foregroundStyle(color)
                            }
                        }
                        // average line
                        if avg != nil && avgTitle != nil {
                            RuleMark(y: .value(avgTitle!, avg!))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                            .foregroundStyle(color)
                            .opacity(0.7)
                        }
                    } else {
                    // data loading
                    }
                }
                .chartYScale(domain: dataRange)
                .frame(height: 120)
            }
            .background(Color.commonElementBackground)
        }
    }
}

#Preview {
    HistoryTrackInfoChartView(title: "Chart title!", data: nil, color: .blue, onlyPositive: true, avg: 24, avgTitle: "avg")
}

#Preview {
    let data = [
        ChartPoint(date: Date(timeIntervalSinceNow: -2000), value: 23),
        ChartPoint(date: Date(timeIntervalSinceNow: -1800), value: 26),
        ChartPoint(date: Date(timeIntervalSinceNow: -1500), value: 32),
        ChartPoint(date: Date(timeIntervalSinceNow: -1200), value: 29)
    ]
    HistoryTrackInfoChartView(title: "Chart ttl", data: data, color: .green, onlyPositive: true, avg: 27, avgTitle: "avg")
}
