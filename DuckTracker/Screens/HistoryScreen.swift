import SwiftUI

struct HistoryScreen: View {

    @Binding var selectedTab: Int

    var body: some View {
        HistoryListView(selectedTab: $selectedTab)
    }

}

#Preview {
    HistoryScreen(selectedTab: .constant(3))
}
