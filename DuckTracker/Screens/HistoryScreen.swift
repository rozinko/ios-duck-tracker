import SwiftUI

struct HistoryScreen: View {

    @Binding var selectedTab: Int

    var body: some View {
        HistoryListView(selectedTab: $selectedTab)
    }

}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen(selectedTab: .constant(3))
    }
}
