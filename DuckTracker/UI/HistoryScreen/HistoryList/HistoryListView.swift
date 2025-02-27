import SwiftUI

struct HistoryListView: View {

    @Binding var selectedTab: Int

    @ObservedObject var dataProvider = DataProvider.shared

    var body: some View {

        if dataProvider.historyTracks.isEmpty && dataProvider.loading {

            // Loading...
            VStack {
                Spacer(minLength: 30)
                VStack(spacing: 10) {
                    ProgressView()
                    HStack {
                        Spacer()
                        Text(".loading".localized()).font(Font.title2.bold())
                        Spacer()
                    }
                }
                Spacer(minLength: 30)
            }

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
