import SwiftUI

public struct HistoryListSection: Identifiable {
    public var id = UUID()

    let date: String

    let day: String
    let month: String
    let year: String

    let isToday: Bool
    let isYesterday: Bool

    init(fromTimestamp dateSection: Date) {
        let df = DateFormatter()

        df.dateFormat = "yyyy-MM-dd"
        date = df.string(from: dateSection)

        df.dateFormat = "d"
        day = df.string(from: dateSection)

        df.dateFormat = "MMM"
        month = df.string(from: dateSection)

        df.dateFormat = "yyyy"
        year = df.string(from: dateSection)

        isToday = Calendar.current.isDateInToday(dateSection)
        isYesterday = Calendar.current.isDateInYesterday(dateSection)
    }
}
