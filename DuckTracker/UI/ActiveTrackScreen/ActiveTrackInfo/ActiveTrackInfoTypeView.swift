import SwiftUI

struct ActiveTrackInfoTypeView: View {

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
                    Spacer()
                    activeTrackType.getLabel(prefix: .short)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
                .foregroundColor(Color.commonText)
                .padding([.leading, .trailing], 10)
            })
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
        }
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 30)
        .padding(1)
        .background(Color.commonElementBackground)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var value: ActiveTrackType = .bike
    ActiveTrackInfoTypeView(activeTrackType: $value)
}
