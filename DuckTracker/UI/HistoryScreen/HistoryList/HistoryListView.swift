import SwiftUI

struct HistoryListView: View {

    @Binding var selectedTab: Int

    @ObservedObject var dataProvider = DataProvider.shared

    var body: some View {

        if dataProvider.isLoading {

            // Loading...
            LoadingView()

        } else if dataProvider.historyTracks.isEmpty {

            // Empty list
            HistoryListEmptyView(selectedTab: $selectedTab)

        } else {

            // List of tracks
            NavigationView {
                List {
                    ForEach(dataProvider.historyTracks.keys.sorted(by: >), id: \.self) { key in
                        let section = HistoryListSection(fromTimestamp: dataProvider.historyTracks[key]!.first!.timestampStart)

                        Section(header: HistoryListSectionView(fromSection: section)) {

                            ForEach(dataProvider.historyTracks[key]!, id: \.id) { shortTrack in
                                NavigationLink(
                                    destination: HistoryTrackInfoWithPreloaderView(shortTrack: shortTrack),
                                    label: {
                                        HistoryListItemView(shortTrack: shortTrack)
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

        }

    }
}
