import SwiftUI

enum TrackInfoElementPosition {
    case normal,
         topLeading, topLeadingCutted,
         bottomLeading, bottomLeadingCutted,
         bottomTrailing, bottomTrailingCutted,
         topTrailing, topTrailingCutted

    var shape: any Shape {
        switch self {
        case .normal:
            return RoundedRectangle(cornerRadius: 2)
        case .topLeading:
            return DuckRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 2, bottomTrailingRadius: 2, topTrailingRadius: 2)
        case .topLeadingCutted:
            return DuckRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 2, bottomTrailingRadius: -43, topTrailingRadius: 2)
        case .bottomLeading:
            return DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 15, bottomTrailingRadius: 2, topTrailingRadius: 2)
        case .bottomLeadingCutted:
            return DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 15, bottomTrailingRadius: 2, topTrailingRadius: -43)
        case .bottomTrailing:
            return DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 2, bottomTrailingRadius: 15, topTrailingRadius: 2)
        case .bottomTrailingCutted:
            return DuckRoundedRectangle(topLeadingRadius: -43, bottomLeadingRadius: 2, bottomTrailingRadius: 15, topTrailingRadius: 2)
        case .topTrailing:
            return DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 2, bottomTrailingRadius: 2, topTrailingRadius: 15)
        case .topTrailingCutted:
            return DuckRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: -43, bottomTrailingRadius: 2, topTrailingRadius: 15)
        }
    }
}

struct TrackInfoElementView: View {

    let title: String
    let text: String

    let leftSpacer: Bool
    let rightSpacer: Bool

    let position: TrackInfoElementPosition

    init(title: String, text: String?, leftSpacer: Bool = false, rightSpacer: Bool = false, position: TrackInfoElementPosition = .normal) {
        self.title = title
        self.text = text ?? "..."

        self.leftSpacer = leftSpacer
        self.rightSpacer = rightSpacer

        self.position = position
    }

    init(title: String, value: String?, unit: String?, leftSpacer: Bool = false, rightSpacer: Bool = false, position: TrackInfoElementPosition = .normal) {
        self.title = title
        self.text = value != nil && unit != nil ? value! + " " + unit! : "..."

        self.leftSpacer = leftSpacer
        self.rightSpacer = rightSpacer

        self.position = position
    }

    var body: some View {
        HStack(spacing: 0) {
            if leftSpacer {
                Spacer(minLength: 43)
            }

            VStack(spacing: 1) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)
                    .multilineTextAlignment(.center)
                Text(text)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonText)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 41, idealHeight: 41, maxHeight: 41, alignment: .center)
            .padding(5)

            if rightSpacer {
                Spacer(minLength: 43)
            }
        }
        .modifier(LiquidGlassModifier(glassShape: .rect, shape: position.shape))
    }
}

#Preview {
    VStack {
        HStack(spacing: 2) {
            VStack(spacing: 2) {
                TrackInfoElementView(title: "Avg. speed", value: "1.7", unit: ".kmh".localized(), rightSpacer: true, position: .topLeadingCutted)
                TrackInfoElementView(title: "Max. speed", value: "7.5", unit: ".kmh".localized(), rightSpacer: true, position: .bottomLeadingCutted)
            }

            VStack(spacing: 2) {
                TrackInfoElementView(title: "Time", text: nil, leftSpacer: true, position: .topTrailingCutted)
                TrackInfoElementView(title: "Distance", value: "2.72", unit: ".km".localized(), leftSpacer: true, position: .bottomTrailingCutted)
            }
        }
        .padding()
        .background(Color.yellow)

        HStack(spacing: 2) {
            VStack(spacing: 2) {
                TrackInfoElementView(title: "Pace", text: "32:29", position: .topLeading)
                TrackInfoElementView(title: "Avg. speed", value: "1.7", unit: ".kmh".localized())
                TrackInfoElementView(title: "Max. speed", value: "7.5", unit: ".kmh".localized(), position: .bottomLeading)
            }

            VStack(spacing: 2) {
                TrackInfoElementView(title: "Uphill", value: "145", unit: ".m".localized(), position: .topTrailing)
                TrackInfoElementView(title: "Time", text: "01:34:06")
                TrackInfoElementView(title: "Distance", value: "2.72", unit: ".km".localized(), position: .bottomTrailing)
            }
        }
        .padding()
        .background(Color.yellow)
    }
}
