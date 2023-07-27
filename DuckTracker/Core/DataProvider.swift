import Foundation
import MapKit

public class DataProvider: NSObject, ObservableObject {

    static let shared = DataProvider()

    @Published var tracks: [InfoTrack] = []

    public var historyListSections: [HistoryListSection] {
        var hls: [HistoryListSection] = []

        for track in tracks {
            let dateNext = track.timestampStart.toStringDate()

            if hls.isEmpty || hls.last!.date != dateNext {
                hls.append(HistoryListSection(fromTimestamp: track.timestampStart))
            }
        }

        return hls
    }

    public var historyStats: HistoryStats {
        var hs = HistoryStats()

        for track in tracks {
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
        update()
    }

    public func update() {
        let cdTracks = coreDataProvider.selectTracks()
        var newInfoTracks: [InfoTrack] = []

        for cdTrack in cdTracks {
            let infoTrack = InfoTrack(fromCoreDataTrack: cdTrack)
            newInfoTracks.append(infoTrack)
        }

        self.tracks = newInfoTracks
    }

    public func addTrack(activeTrack: ActiveTrack, title: String, type: ActiveTrackType) -> Bool {
        let addResult = coreDataProvider.addTrack(activeTrack: activeTrack, title: title, type: type)

        update()

        return addResult
    }

    public func updateTrack(infoTrack: InfoTrack, title: String, type: ActiveTrackType) -> Bool {
        let updateResult = infoTrack.cdTrack != nil ? coreDataProvider.updateTrack(cdTrack: infoTrack.cdTrack!, title: title, type: type) : false

        update()

        return updateResult
    }

    public func deleteTrack(infoTrack: InfoTrack?) -> Bool {
        if infoTrack != nil && infoTrack?.cdTrack != nil {
            let deleteResult = coreDataProvider.deleteTrack(cdTrack: infoTrack!.cdTrack!)

            update()

            return deleteResult
        }

        update()

        return false
    }

    public func selectLastTrackType() -> ActiveTrackType? {
        return tracks.isEmpty ? nil : tracks.first!.type
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
