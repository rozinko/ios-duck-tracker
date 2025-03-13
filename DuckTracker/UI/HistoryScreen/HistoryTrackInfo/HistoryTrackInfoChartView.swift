import SwiftUI
import Charts

struct ChartPoint: Hashable {
    let date: Date
    let value: Double
}

struct HistoryTrackInfoChartView: View {

    @Binding var selectedPoint: Int?

    let title: String

    let data: [ChartPoint]?
    let color: Color
    let onlyPositive: Bool

    let avg: Double?
    let avgTitle: String?

    var dataRange: ClosedRange<Double> = ClosedRange(uncheckedBounds: (lower: 0, upper: 0))

    init(selectedPoint: Binding<Int?>, title: String, data: [ChartPoint]?, color: Color, onlyPositive: Bool, avg: Double?, avgTitle: String?) {
        self._selectedPoint = selectedPoint
        self.title = title
        self.onlyPositive = onlyPositive
        self.data = data
        self.color = color
        self.avg = avg
        self.avgTitle = avgTitle

        self.dataRange = calcDataRange()
    }

    init(selectedPoint: Binding<Int?>, title: String, data: [ChartPoint]?, color: Color, onlyPositive: Bool) {
        self.init(selectedPoint: selectedPoint, title: title, data: data, color: color, onlyPositive: onlyPositive, avg: nil, avgTitle: nil)
    }

    private func calcDataRange() -> ClosedRange<Double> {
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
                                y: .value(".value".localized(), \.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(color)
                        } else {
                            ForEach(data!, id: \.date) { point in
                                LineMark(
                                    x: .value(".time".localized(), point.date),
                                    y: .value(".value".localized(), point.value)
                                )
                                .interpolationMethod(.catmullRom)
//                                .mask { RectangleMark() }
                                .foregroundStyle(color)
                            }
                        }
                        // average line
                        if avg != nil && avgTitle != nil {
                            RuleMark(y: .value(avgTitle!, avg!))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                            .foregroundStyle(color)
//                            .opacity(0.5)
                        }
                        // selected point
                        if self.selectedPoint != nil && self.selectedPoint! >= 0 && self.selectedPoint! < (data?.count ?? 0) {
                            var annotationPosition: AnnotationPosition {
                                if selectedPoint! <= data!.count / 4 {
                                    return .bottomTrailing
                                }
                                if selectedPoint! >= data!.count * 3 / 4 {
                                    return .bottomLeading
                                }
                                return .bottom
                            }

                            RuleMark(
                                x: .value(".time".localized(), data![selectedPoint!].date)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 1))
                            .foregroundStyle(color)
//                            .opacity(0.5)
                            .annotation(position: annotationPosition, spacing: 0) {
                                VStack {
                                    Text(data![selectedPoint!].date.toString(dateFormat: "HH:mm:ss"))
                                        .padding([.leading, .trailing], 3)
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.commonWhite)
                                        .background(color)
                                        .clipShape(Rectangle())
                                }
                                .padding(.top, 3)
                            }

                            PointMark(
                                x: .value(".time".localized(), data![selectedPoint!].date),
                                y: .value(".value".localized(), data![selectedPoint!].value)
                            )
                            .foregroundStyle(color)
                            .annotation(position: annotationPosition, spacing: 2) {
                                Text(data![selectedPoint!].value.toStringInt())
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(3)
                                    .foregroundStyle(Color.commonWhite)
                                    .background(color)
                                    .clipShape(Capsule())
                            }

                        }
                    }
                }
                .chartYScale(domain: dataRange)
                .frame(height: 120)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // Convert the gesture location to the coordinate space of the plot area.
                                        let origin = geometry[proxy.plotAreaFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        // Get the x (date) and y (value) value from the location.
                                        let (date, _) = proxy.value(at: location, as: (Date, Double).self) ?? (nil, nil)
                                        var i = 0
                                        if data != nil && date != nil {
                                            while i < data!.count && data![i].date < date! {
                                                i += 1
                                            }
                                        }
                                        selectedPoint = max(0, min(i, data!.count-1))
//                                        print(self.selectedPoint ?? "no selected")
                                    }
                                    .onEnded { _ in
                                        self.selectedPoint = nil
                                    }
                            )
                    }
                }
            }
            .background(Color.commonElementBackground)
        }
    }
}

#Preview {
    HistoryTrackInfoChartView(selectedPoint: .constant(nil), title: "Chart title!", data: nil, color: .blue, onlyPositive: true, avg: 24, avgTitle: "avg")
}

#Preview {
    let data = [
        ChartPoint(date: Date(timeIntervalSinceNow: -2000), value: 23),
        ChartPoint(date: Date(timeIntervalSinceNow: -1800), value: 26),
        ChartPoint(date: Date(timeIntervalSinceNow: -1500), value: 32),
        ChartPoint(date: Date(timeIntervalSinceNow: -1200), value: 29)
    ]
    HistoryTrackInfoChartView(selectedPoint: .constant(nil), title: "Chart ttl", data: data, color: .green, onlyPositive: true, avg: 27, avgTitle: "avg")
}

#Preview {
    let data = [
        ChartPoint(date: Date(timeIntervalSinceNow: -2000), value: 23),
        ChartPoint(date: Date(timeIntervalSinceNow: -1800), value: 26),
        ChartPoint(date: Date(timeIntervalSinceNow: -1500), value: 32),
        ChartPoint(date: Date(timeIntervalSinceNow: -1400), value: 23),
        ChartPoint(date: Date(timeIntervalSinceNow: -1300), value: 21),
        ChartPoint(date: Date(timeIntervalSinceNow: -1250), value: 19),
        ChartPoint(date: Date(timeIntervalSinceNow: -1190), value: 23),
        ChartPoint(date: Date(timeIntervalSinceNow: -1000), value: 24),
        ChartPoint(date: Date(timeIntervalSinceNow: -900), value: 26),
        ChartPoint(date: Date(timeIntervalSinceNow: -800), value: 24)
    ]
    VStack {
        HistoryTrackInfoChartView(
            selectedPoint: .constant(0), title: "Chart name", data: data,
            color: .commonOrange, onlyPositive: true, avg: 22, avgTitle: "avg")

        HistoryTrackInfoChartView(
            selectedPoint: .constant(1), title: "Chart name", data: data,
            color: .commonOrange, onlyPositive: true, avg: 22, avgTitle: "avg")

        HistoryTrackInfoChartView(
            selectedPoint: .constant(3), title: "Chart name", data: data,
            color: .commonGreen, onlyPositive: true, avg: 22, avgTitle: "avg")

        HistoryTrackInfoChartView(
            selectedPoint: .constant(data.count-2), title: "Chart name", data: data,
            color: .commonBlue, onlyPositive: true, avg: 22, avgTitle: "avg")

        HistoryTrackInfoChartView(
            selectedPoint: .constant(data.count-1), title: "Chart name", data: data,
            color: .commonBlue, onlyPositive: true, avg: 22, avgTitle: "avg")
    }
}
