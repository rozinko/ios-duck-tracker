import SwiftUI

struct MainScreen: View {

    @Binding var selectedTab: Int

    @ObservedObject var dataProvider = DataProvider.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                MainInformerView(selectedTab: $selectedTab)

                StatsBlockView(title: "StatsBlock.today".localized(), historyStatsBlock: dataProvider.historyStats.data[.today]!)

                if dataProvider.historyStats.data[.yesterday]!.isWithData {
                    StatsBlockView(title: "StatsBlock.yesterday".localized(), historyStatsBlock: dataProvider.historyStats.data[.yesterday]!)
                }
                if dataProvider.historyStats.data[.days7]!.isWithData {
                    StatsBlockView(title: "StatsBlock.7days".localized(), historyStatsBlock: dataProvider.historyStats.data[.days7]!)
                }
                if dataProvider.historyStats.data[.days30]!.isWithData {
                    StatsBlockView(title: "StatsBlock.30days".localized(), historyStatsBlock: dataProvider.historyStats.data[.days30]!)
                }
                StatsBlockView(title: "StatsBlock.total".localized(), historyStatsBlock: dataProvider.historyStats.data[.total]!)
            }
            .padding()
        }
        .background(Color.commonBackground)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(selectedTab: .constant(1))
    }
}
