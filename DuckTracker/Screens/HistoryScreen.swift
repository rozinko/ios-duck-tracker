import SwiftUI

struct HistoryScreen: View {

    @Binding var selectedTab: Int

    @ObservedObject var dataProvider = DataProvider.shared

    var body: some View {

        HistoryListView(selectedTab: $selectedTab, historyTracks: dataProvider.historyTracks)

    }

}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen(selectedTab: .constant(3))
    }
}
