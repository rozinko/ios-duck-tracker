import SwiftUI
import Charts

struct DuckTrackChartsView: View {
    @Binding var selectedPoint: Int?

    var chartModel: DuckTrackChartModel
    let visible: DuckTrackChartVisible

    var actualChartTitle: String {
        switch visible {
        case .speed:
            return (chartModel.speedTitle.localized() + " (" + chartModel.speedUnit.localized() + ")").uppercased()
        case .altitude:
            return (chartModel.altitudeTitle.localized() + " (" + chartModel.altitudeUnit.localized() + ")").uppercased()
        case .distance:
            return (chartModel.distanceTitle.localized() + " (" + chartModel.distanceUnit.localized() + ")").uppercased()
        }
    }

    var actualChartColor: Color {
        switch visible {
        case .speed:
            return chartModel.speedColor
        case .altitude:
            return chartModel.altitudeColor
        case .distance:
            return chartModel.distanceColor
        }
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 5) {
                Text(actualChartTitle)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)

                Chart {
                    if chartModel.data != nil {
                        // main data
                        if #available(iOS 18.0, *) {
                            LinePlot(
                                chartModel.data!,
                                x: .value(".time".localized(), \.date),
                                y: .value(".value".localized(), visible == .distance ? \.distance : (visible == .altitude ? \.altitude : \.speed))
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(actualChartColor)
                        } else {
                            ForEach(chartModel.data!, id: \.date) { point in
                                LineMark(
                                    x: .value(".time".localized(), point.date),
                                    y: .value(".value".localized(), visible == .distance ? point.distance : (visible == .altitude ? point.altitude : point.speed))
                                )
                                .interpolationMethod(.catmullRom)
//                                .mask { RectangleMark() }
                                .foregroundStyle(actualChartColor)
                            }
                        }

                        // average line
                        if visible == .speed {
                            RuleMark(y: .value(chartModel.avgSpeedTitle, chartModel.avgSpeed))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                            .foregroundStyle(actualChartColor)
//                            .opacity(0.5)
                        }

                        // selected point
                        if self.selectedPoint != nil && self.selectedPoint! >= 0 && self.selectedPoint! < (chartModel.data?.count ?? 0) {
                            var annotationPosition: AnnotationPosition {
                                if selectedPoint! <= chartModel.data!.count / 4 {
                                    return .bottomTrailing
                                }
                                if selectedPoint! >= chartModel.data!.count * 3 / 4 {
                                    return .bottomLeading
                                }
                                return .bottom
                            }

                            RuleMark(
                                x: .value(".time".localized(), chartModel.data![selectedPoint!].date)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 1))
                            .foregroundStyle(actualChartColor)
//                            .opacity(0.5)
                            .annotation(position: annotationPosition, spacing: 0) {
                                VStack {
                                    Text(chartModel.data![selectedPoint!].date.toString(dateFormat: "HH:mm:ss"))
                                        .padding([.leading, .trailing], 3)
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.commonWhite)
                                        .background(actualChartColor)
                                        .clipShape(Rectangle())
                                }
                                .padding(.top, 3)
                            }

                            PointMark(
                                x: .value(".time".localized(), chartModel.data![selectedPoint!].date),
                                y: .value(".value".localized(), visible == .distance ? chartModel.data![selectedPoint!].distance : (visible == .altitude ? chartModel.data![selectedPoint!].altitude : chartModel.data![selectedPoint!].speed))
                            )
                            .foregroundStyle(actualChartColor)
                            .annotation(position: annotationPosition, spacing: 2) {
                                Text((visible == .distance ? chartModel.data![selectedPoint!].distance : (visible == .altitude ? chartModel.data![selectedPoint!].altitude : chartModel.data![selectedPoint!].speed)).toStringInt())
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(3)
                                    .foregroundStyle(Color.commonWhite)
                                    .background(actualChartColor)
                                    .clipShape(Capsule())
                            }

                        }
                    }
                }
                .animation(.spring, value: visible)
                .chartYScale(domain: visible == .distance ? chartModel.distanceDataRange : (visible == .altitude ? chartModel.altitudeDataRange : chartModel.speedDataRange))
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
                                        if chartModel.data != nil && date != nil {
                                            while i < chartModel.data!.count && chartModel.data![i].date < date! {
                                                i += 1
                                            }
                                        }
                                        selectedPoint = max(0, min(i, chartModel.data!.count-1))
//                                        print(self.selectedPoint ?? "no selected")
                                    }
                                    .onEnded { _ in
                                        self.selectedPoint = nil
                                    }
                            )
                    }
                }
            }
            .padding(10)
        }
    }
}

#Preview {
    let duckChartModel = DuckTrackChartModel(
        data: [
            DuckTrackChartPoint(speed: 22, altitude: 54, distance: 1, date: Date(timeIntervalSince1970: 1685551781)),
            DuckTrackChartPoint(speed: 24, altitude: 58, distance: 2, date: Date(timeIntervalSince1970: 1685552781)),
            DuckTrackChartPoint(speed: 27, altitude: 59, distance: 3, date: Date(timeIntervalSince1970: 1685553781)),
            DuckTrackChartPoint(speed: 28, altitude: 56, distance: 4, date: Date(timeIntervalSince1970: 1685554781)),
            DuckTrackChartPoint(speed: 23, altitude: 53, distance: 5, date: Date(timeIntervalSince1970: 1685555781)),
            DuckTrackChartPoint(speed: 17, altitude: 55, distance: 6, date: Date(timeIntervalSince1970: 1685555981)),
            DuckTrackChartPoint(speed: 19, altitude: 55, distance: 7, date: Date(timeIntervalSince1970: 1685558781))
        ],
        avgSpeed: 21.5
    )

    let duckChartModel2 = DuckTrackChartModel(
        data: [
            DuckTrackChartPoint(speed: 22, altitude: 54, distance: 100, date: Date(timeIntervalSince1970: 1685551781)),
            DuckTrackChartPoint(speed: 24, altitude: 58, distance: 300, date: Date(timeIntervalSince1970: 1685552781)),
            DuckTrackChartPoint(speed: 27, altitude: 59, distance: 500, date: Date(timeIntervalSince1970: 1685553781)),
            DuckTrackChartPoint(speed: 28, altitude: 56, distance: 700, date: Date(timeIntervalSince1970: 1685554781)),
            DuckTrackChartPoint(speed: 23, altitude: 53, distance: 900, date: Date(timeIntervalSince1970: 1685555781)),
            DuckTrackChartPoint(speed: 17, altitude: 55, distance: 1100, date: Date(timeIntervalSince1970: 1685555981)),
            DuckTrackChartPoint(speed: 19, altitude: 55, distance: 1300, date: Date(timeIntervalSince1970: 1685558781))
        ],
        avgSpeed: 21.5
    )

    VStack(spacing: 15) {
        DuckTrackChartsView(selectedPoint: .constant(2), chartModel: duckChartModel, visible: .speed)
        DuckTrackChartsView(selectedPoint: .constant(3), chartModel: duckChartModel, visible: .altitude)
        DuckTrackChartsView(selectedPoint: .constant(5), chartModel: duckChartModel, visible: .distance)
        DuckTrackChartsView(selectedPoint: .constant(6), chartModel: duckChartModel2, visible: .distance)
    }
}
