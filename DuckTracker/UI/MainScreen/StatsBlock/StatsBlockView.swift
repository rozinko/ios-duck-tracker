import SwiftUI

struct StatsBlockView: View {

    let title: String
    let historyStatsBlock: HistoryStatsBlock

    var sorted: [HistoryStatsBlockItem] {
        var result: [HistoryStatsBlockItem] = []

        for (key, value) in historyStatsBlock.data where value.distance > 0 {
            result.append(HistoryStatsBlockItem(type: key, distance: value.distance, timeInSeconds: value.timeInSeconds))
        }

        result.sort { $0.distance > $1.distance }

        return result
    }

    var body: some View {
        CommonStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(Font.title3.bold())
                    .foregroundColor(Color.commonOrange)

                VStack(spacing: 7) {
                    if historyStatsBlock.isWithData {
                        ForEach(sorted) { item in
                            HStack(spacing: 5) {
                                item.type.getLabel()
                                Spacer()
                                Text(item.distance.prepareString())
                            }.font(Font.subheadline)
                        }
                    } else {
                        HStack(spacing: 5) {
                            Text(".nodata".localized())
                            Spacer()
                        }.font(Font.subheadline)
                    }
                }
            }
        }
    }
}

struct StatsBlockView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatsBlockView(title: "StatsBlock.7days".localized(), historyStatsBlock: HistoryStatsBlock(data: [
                .bike: HistoryStatsInfo(distance: 129300, timeInSeconds: 300),
                .run: HistoryStatsInfo(distance: 90190, timeInSeconds: 450),
                .hike: HistoryStatsInfo(distance: 23300, timeInSeconds: 280)
            ]))
        }.padding()

        VStack {
            StatsBlockView(title: "StatsBlock.today".localized(), historyStatsBlock: HistoryStatsBlock(data: [:]))
        }.padding()

        VStack {
            StatsBlockView(title: "StatsBlock.total".localized(), historyStatsBlock: HistoryStatsBlock(data: [
                .airplane: HistoryStatsInfo(distance: 1233000, timeInSeconds: 300),
                .bike: HistoryStatsInfo(distance: 129000, timeInSeconds: 300),
                .boat: HistoryStatsInfo(distance: 38000, timeInSeconds: 300),
                .bus: HistoryStatsInfo(distance: 12900, timeInSeconds: 300),
                .car: HistoryStatsInfo(distance: 149200, timeInSeconds: 300),
                .electrobike: HistoryStatsInfo(distance: 9230, timeInSeconds: 300),
                .electroscooter: HistoryStatsInfo(distance: 8122, timeInSeconds: 300),
                .hike: HistoryStatsInfo(distance: 49120, timeInSeconds: 300),
                .other: HistoryStatsInfo(distance: 100, timeInSeconds: 300),
                .run: HistoryStatsInfo(distance: 33333, timeInSeconds: 300),
                .scooter: HistoryStatsInfo(distance: 23890, timeInSeconds: 300),
                .train: HistoryStatsInfo(distance: 680780, timeInSeconds: 300),
                .walk: HistoryStatsInfo(distance: 1233, timeInSeconds: 300)
            ]))
        }.padding()
    }
}
