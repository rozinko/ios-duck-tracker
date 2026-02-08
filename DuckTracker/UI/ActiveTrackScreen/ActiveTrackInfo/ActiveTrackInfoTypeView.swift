import SwiftUI

fileprivate struct ActiveTrackInfoTypeLiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: .capsule)
        } else if #available(iOS 16.0, *) {
            content
                .background(Color.commonElementBackground.opacity(0.7))
                .clipShape(.capsule)
        } else {
            content
                .background(Color.commonElementBackground.opacity(0.7))
        }
    }
}

struct ActiveTrackInfoTypeView: View {

    let isRecording: Bool

    @Binding var activeTrackType: ActiveTrackType

    var body: some View {
        HStack(spacing: 5) {
            Menu(content: {
                Picker(selection: $activeTrackType, label: EmptyView()) {
                    ForEach(ActiveTrackType.allCases, id: \.self) { item in
                        item.getLabel(prefix: .full)
                            .foregroundColor(Color.commonText)
                    }
                }
            }, label: {
                HStack {
                    if isRecording {
                        activeTrackType.getIcon()
                    } else {
                        activeTrackType.getLabel(prefix: .short)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                .foregroundColor(Color.commonText)
                .padding([.leading, .trailing], 10)
            })
        }
        .padding(10)
        .modifier(ActiveTrackInfoTypeLiquidGlassModifier())
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var value: ActiveTrackType = .bike
    VStack {
        Spacer()
        HStack {
            Spacer()
            ActiveTrackInfoTypeView(isRecording: true, activeTrackType: $value)
            Spacer()
        }
        Spacer()
        HStack {
            Spacer()
            ActiveTrackInfoTypeView(isRecording: false, activeTrackType: $value)
            Spacer()
        }
        Spacer()
    }
    .padding()
    .background(Color.yellow)
}
