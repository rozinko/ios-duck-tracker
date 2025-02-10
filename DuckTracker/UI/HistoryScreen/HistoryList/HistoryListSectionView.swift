import SwiftUI

struct HistoryListSectionView: View {

    let section: HistoryListSection

    var day: String { self.section.day }
    var month: String { self.section.month }
    var year: String { self.section.year }

    var isToday: Bool { self.section.isToday }
    var isYesterday: Bool { self.section.isYesterday }

    var showYear: Bool { year != Date().toStringYear() }

    init(fromSection section: HistoryListSection) {
        self.section = section
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

            if showYear {
                Text(year)
                    .bold()
                    .foregroundColor(.accentColor)
            }

            Spacer()
        }
    }
}

//#Preview {
//    // Start List {} from HistoryListView
//    let data: [HistoryListSection] = [-10, -3600, -86400, -86400*2, -86400*7, -86400*20,
//                 -86400*180, -86400*360, -86400*720, -86400*1080].map {
//        HistoryListSection(fromTimestamp: Date(timeIntervalSinceNow: $0))
//    }
//    List {
//        ForEach(data, id: \.self) { section in
//            Section(header: HistoryListSectionView(fromSection: section)) { }
//        }
//    }
//    .navigationBarTitle(".tab.history".localized())
//    .navigationViewStyle(.stack)
//    .listStyle(GroupedListStyle())
//    // End of List {}
//}
