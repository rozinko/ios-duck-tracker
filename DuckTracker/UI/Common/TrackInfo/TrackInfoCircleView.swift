import SwiftUI

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
            .background(Color.commonElementBackground)
            .frame(width: 84, height: 84, alignment: .center)
            .cornerRadius(42)
        }
        .background(Color.commonBorder)
        .frame(width: 86, height: 86, alignment: .center)
        .cornerRadius(43)
    }
}

struct TrackInfoCircleView_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfoCircleView(title: "Title", text: "000", unit: ".kmh".localized())
        TrackInfoCircleView(title: "Title", text: nil, unit: nil)
    }
}
