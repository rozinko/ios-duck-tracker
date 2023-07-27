import SwiftUI

struct TrackInfoElementView: View {

    let title: String
    let text: String

    let leftSpacer: Bool
    let rightSpacer: Bool

    init(title: String, text: String?, leftSpacer: Bool = false, rightSpacer: Bool = false) {
        self.title = title
        self.text = text ?? "..."

        self.leftSpacer = leftSpacer
        self.rightSpacer = rightSpacer
    }

    init(title: String, value: String?, unit: String?, leftSpacer: Bool = false, rightSpacer: Bool = false) {
        self.title = title
        self.text = value != nil && unit != nil ? value! + " " + unit! : "..."

        self.leftSpacer = leftSpacer
        self.rightSpacer = rightSpacer
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
        .background(Color.commonElementBackground)
    }
}

struct TrackInfoElementView_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfoElementView(title: "Title", text: "00:00:00")
        TrackInfoElementView(title: "Title", text: nil)
        TrackInfoElementView(title: "Title", value: "123", unit: ".km".localized())
    }
}
