import SwiftUI

struct HistoryListSectionView: View {

    let day: String
    let month: String
    let year: String

    let isToday: Bool
    let isYesterday: Bool

    let showYear: Bool

    init(fromSection section: HistoryListSection) {
        let dateNow = Date()

        day = section.day
        month = section.month
        year = section.year

        isToday = section.isToday
        isYesterday = section.isYesterday

        showYear = year != dateNow.toStringYear()
    }

    var body: some View {
        HStack {
            Text(day)
                .bold()
                .frame(width: 18, height: 18, alignment: .center)
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                .foregroundColor(.accentColor)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor))

            Text(month)
                .bold()
                .foregroundColor(.accentColor)

            if isToday {
                Text(".today".localized())
            }

            if isYesterday {
                Text(".yesterday".localized())
            }

            Spacer()

            if showYear {
                Text(year)
            }
        }
    }
}
