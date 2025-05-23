import SwiftUI

struct WrapperView: View {

    @State var selectedTab = 1

    var body: some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $selectedTab) {
                Tab(".tab.home", systemImage: "flag.fill", value: 1) {
                    MainScreen(selectedTab: $selectedTab)
                }
                Tab(".tab.track", systemImage: "play.fill", value: 2) {
                    ActiveTrackScreen(selectedTab: $selectedTab)
                }
                Tab(".tab.history", systemImage: "calendar", value: 3) {
                    HistoryScreen(selectedTab: $selectedTab)
                }
                Tab(".tab.settings", systemImage: "gear", value: 4) {
                    SettingsScreen(selectedTab: $selectedTab)
                }
            }
            .tabViewStyle(.tabBarOnly)
        } else {
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
}

#Preview {
    WrapperView()
}
