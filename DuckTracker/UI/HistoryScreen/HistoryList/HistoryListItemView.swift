import SwiftUI

struct HistoryListItemView: View {

    let shortTrack: ShortTrack

    init(shortTrack: ShortTrack) {
        self.shortTrack = shortTrack
    }

    var body: some View {

        VStack {
            HStack {
                HStack(spacing: 5) {
                    shortTrack.type.getIcon()

                    Text(shortTrack.title).bold()
                }
                .foregroundColor(.accentColor)

                Spacer()
            }
            .padding(.bottom, 3)

            HStack(spacing: 5) {
                VStack {
                    if shortTrack.type == .run || shortTrack.type == .walk || shortTrack.type == .hike {
                        Text(".pace".localized())
                            .font(.caption)
                            .bold()
                        Text(shortTrack.getPaceAsString())
                    } else {
                        Text(".avgspeed.short".localized())
                            .font(.caption)
                            .bold()
                        Text(shortTrack.avgSpeed.prepareStringKmh(withUnit: true))
                    }
                }

                Spacer()

                VStack {
                    Text(".time".localized())
                        .font(.caption)
                        .bold()
                    Text(shortTrack.getTimeAsString())
                }

                Spacer()

                VStack {
                    Text(".distance".localized())
                        .font(.caption)
                        .bold()
                    Text(shortTrack.distance.prepareString())
                }
            }
        }
        .padding(.all, 3)
    }
}
