import SwiftUI

struct HistoryListView: View {

    @Binding var selectedTab: Int

    let historyTracks: [String: [InfoTrack]]

    var historyDates: [String] {
        historyTracks.keys.sorted { $0 > $1 }
    }

    var body: some View {
        if !historyDates.isEmpty {

            NavigationView {
                List {
                    ForEach(historyDates, id: \.self) { key in
                        let section = HistoryListSection(fromTimestamp: historyTracks[key]!.first!.timestampStart)

                        Section(header: HistoryListSectionView(fromSection: section)) {

                            ForEach(historyTracks[key]!, id: \.id) { infoTrack in
                                NavigationLink(
                                    destination: HistoryTrackInfoView(infoTrack: infoTrack),
                                    label: {
                                        HistoryListItemView(infoTrack: infoTrack)
                                    }
                                )
                            }

                        }

                    }
                }
                .navigationBarTitle(".tab.history".localized())
                .navigationViewStyle(.stack)
                .listStyle(GroupedListStyle())
            }

        } else {
            HistoryListEmptyView(selectedTab: $selectedTab)
        }
    }
}
