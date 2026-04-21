import SwiftUI

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
        .modifier(LiquidGlassModifier(glassShape: .capsule, shape: .capsule))
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
