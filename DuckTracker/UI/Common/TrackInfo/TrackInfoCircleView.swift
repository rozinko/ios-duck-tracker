import SwiftUI

struct TrackInfoCircleLiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: .circle)
        } else if #available(iOS 16.0, *) {
            content
                .background(Color.commonElementBackground.opacity(0.7))
                .clipShape(.circle)
        } else {
            content
                .background(Color.commonElementBackground.opacity(0.7))
        }
    }
}

struct TrackInfoCircleView: View {

    let title: String
    let text: String
    let unit: String

    init(title: String, text: String?, unit: String?) {
        self.title = title
        self.text = text ?? "..."
        self.unit = unit ?? ""
    }

    var body: some View {
        VStack(spacing: 1) {
            VStack(spacing: 1) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .bottom)

                Text(text)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonText)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 22, maxHeight: 22, alignment: .center)

                Text(unit)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.commonTitle)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(width: 84, height: 84, alignment: .center)
        }
        .modifier(TrackInfoCircleLiquidGlassModifier())
        .frame(width: 86, height: 86, alignment: .center)
    }
}

struct TrackInfoCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            TrackInfoCircleView(title: "Title", text: "000", unit: ".kmh".localized())
            TrackInfoCircleView(title: "Title", text: nil, unit: nil)
        }
        .padding()
        .background(Color.yellow)
    }
}
