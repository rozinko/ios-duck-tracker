import SwiftUI

struct WrapperView: View {

    @State var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label(".tab.home", systemImage: "flag.fill")
                }
                .tag(1)
            ActiveTrackScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label(".tab.track", systemImage: "play.fill")
                }
                .tag(2)
            HistoryScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label(".tab.history", systemImage: "calendar")
                }
                .tag(3)
            SettingsScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label(".tab.settings", systemImage: "gear")
                }
                .tag(4)
        }
        .accentColor(Color.wrapperViewAccent)
    }
}

#Preview {
    WrapperView()
}
