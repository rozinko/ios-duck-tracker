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
                activeTrackType.getLabel(prefix: .short)
                    .foregroundColor(Color.commonText)
            })
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
        }
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 30)
        .padding(1)
        .background(Color.commonElementBackground)
    }
}

struct ActiveTrackInfoTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackInfoTypeView(activeTrackType: .constant(.hike))
    }
}
