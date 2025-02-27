import Foundation
import MapKit

public class DataProvider: NSObject, ObservableObject {

    static let shared = DataProvider()

    // флаг обозначающий, что сейчас идёт обновление данных из CoreData
    @Published var loading: Bool = true

    // все короткие треки из CoreData хранятся тут
    var shortTracks: [ShortTrack] = []

    // Формат данных для списка истории с группировкой по дате в формате YYYY-MM-DD в строке
    var historyTracks: [String: [ShortTrack]] = [:]

    public var historyStats: HistoryStats {
        var hs = HistoryStats()

        for track in shortTracks {
            let days = Calendar.current.dateComponents([.day], from: track.timestampStart, to: Date()).day!
            let isToday = Calendar.current.isDateInToday(track.timestampStart)
            let isYesterday = Calendar.current.isDateInYesterday(track.timestampStart)

            if days <= 30 {
                hs.data[.days30]?.data[track.type]?.distance += track.distance
                hs.data[.days30]?.data[track.type]?.timeInSeconds += Int(track.timeInSeconds)
            }

            if days <= 7 {
                hs.data[.days7]?.data[track.type]?.distance += track.distance
                hs.data[.days7]?.data[track.type]?.timeInSeconds += Int(track.timeInSeconds)
            }

            if isYesterday {
                hs.data[.yesterday]?.data[track.type]?.distance += track.distance
                hs.data[.yesterday]?.data[track.type]?.timeInSeconds += Int(track.timeInSeconds)
            }

            if isToday {
                hs.data[.today]?.data[track.type]?.distance += track.distance
                hs.data[.today]?.data[track.type]?.timeInSeconds += Int(track.timeInSeconds)
            }

            hs.data[.total]?.data[track.type]?.distance += track.distance
            hs.data[.total]?.data[track.type]?.timeInSeconds += Int(track.timeInSeconds)
        }

        return hs
    }

    private let coreDataProvider = CoreDataProvider.shared

    override public init() {
        super.init()
        selectAll()
    }

    public func selectAll() {
        let methodStart = Date()
        self.loading = true

        coreDataProvider.selectAll({ [weak self, methodStart] cdTracks in
            let shortTracks: [ShortTrack] = cdTracks.map { ShortTrack(fromCoreDataTrack: $0) }

            var historyTracks: [String: [ShortTrack]] = [:]
            for track in shortTracks {
                historyTracks[track.timestampStart.toStringDate(), default: []].append(track)
            }

            self?.shortTracks = shortTracks
            self?.historyTracks = historyTracks

            self?.loading = false

            let executionTime = Int(Date().timeIntervalSince(methodStart) * 1000)
            print("DataProvider // selectAll(): Execution time: \(executionTime) ms")
        })
    }

    public func addTrack(activeTrack: ActiveTrack, title: String, type: ActiveTrackType) -> Bool {
        let addResult = coreDataProvider.addTrack(activeTrack: activeTrack, title: title, type: type)

        selectAll()

        return addResult
    }

    public func updateTrack(infoTrack: InfoTrack, title: String, type: ActiveTrackType) -> Bool {
        let updateResult = infoTrack.cdTrack != nil ? coreDataProvider.updateTrack(cdTrack: infoTrack.cdTrack!, title: title, type: type) : false

        selectAll()

        return updateResult
    }

    public func deleteTrack(infoTrack: InfoTrack?) -> Bool {
        if infoTrack != nil && infoTrack?.cdTrack != nil {
            let deleteResult = coreDataProvider.deleteTrack(cdTrack: infoTrack!.cdTrack!)

            selectAll()

            return deleteResult
        }

        selectAll()

        return false
    }

    public func selectLastTrackType() -> ActiveTrackType? {
        return shortTracks.isEmpty ? nil : shortTracks.first!.type
    }

}

struct HistoryStatsInfo {
    var distance: CLLocationDistance = 0
    var timeInSeconds: Int = 0
}

struct HistoryStatsBlock {
    var data: [ActiveTrackType: HistoryStatsInfo] = [:]

    var isWithData: Bool {
        for (_, value) in data where value.distance > 0 {
            return true
        }

        return false
    }

    init(data: [ActiveTrackType: HistoryStatsInfo]) {
        self.data = data
    }

    init() {
        for type in ActiveTrackType.allCases {
            data[type] = HistoryStatsInfo()
        }
    }
}

enum HistoryStatsInterval: CaseIterable {
    case today, yesterday, days7, days30, total
}

public struct HistoryStats {
    var data: [HistoryStatsInterval: HistoryStatsBlock] = [:]

    init() {
        for interval in HistoryStatsInterval.allCases {
            data[interval] = HistoryStatsBlock()
        }
    }
}
