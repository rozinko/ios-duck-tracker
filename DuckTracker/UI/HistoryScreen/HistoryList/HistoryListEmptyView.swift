import SwiftUI

struct HistoryListEmptyView: View {

    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                Text("HistoryListEmptyView.title".localized())
                    .font(.title)
                Text("HistoryListEmptyView.description".localized())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button("HistoryListEmptyView.button".localized(), action: {
                selectedTab = 2
            }).buttonStyle(ButtonOrangeFilledStyle())

        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 60)
    }
}

struct HistoryListEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListEmptyView(selectedTab: .constant(2))
    }
}
