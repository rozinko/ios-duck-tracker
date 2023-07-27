import SwiftUI

struct HistoryListView: View {

    @Binding var selectedTab: Int

    let sections: [HistoryListSection]
    let infoTracks: [InfoTrack]

    var body: some View {
        if !sections.isEmpty && !infoTracks.isEmpty {

            // Start NavigationView
            NavigationView {

                // Start List {}
                List {
                    ForEach(sections, id: \.id) { section in

                        // Start Section {}
                        Section(header: HistoryListSectionView(fromSection: section)) {
                            ForEach(infoTracks.filter {$0.timestampStart.toStringDate() == section.date}, id: \.id) { infoTrack in
                                NavigationLink(
                                    destination: HistoryTrackInfoView(infoTrack: infoTrack),
                                    label: { HistoryListItemView(infoTrack: infoTrack) }
                                )
                            }
                        }
                        // End of Section {}

                    }
                }
                .navigationBarTitle(".tab.history".localized())
                .navigationViewStyle(.stack)
                .listStyle(GroupedListStyle())
                // End of List {}

            }
            // End of NavigationView

        } else {
            HistoryListEmptyView(selectedTab: $selectedTab)
        }
    }
}
