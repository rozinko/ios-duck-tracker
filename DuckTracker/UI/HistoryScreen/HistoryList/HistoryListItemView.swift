import SwiftUI

struct HistoryListItemView: View {

    let infoTrack: InfoTrack

    var body: some View {

        VStack {
            HStack {
                HStack(spacing: 5) {
                    infoTrack.type.getIcon()

                    Text(infoTrack.title).bold()
                }
                .foregroundColor(.accentColor)

                Spacer()
            }
            .padding(.bottom, 3)

            HStack(spacing: 5) {
                VStack {
                    if infoTrack.type == .run || infoTrack.type == .walk || infoTrack.type == .hike {
                        Text(".pace".localized())
                            .font(.caption)
                            .bold()
                        Text(infoTrack.getPaceAsString())
                    } else {
                        Text(".avgspeed.short".localized())
                            .font(.caption)
                            .bold()
                        Text(infoTrack.avgSpeed.prepareStringKmh(withUnit: true))
                    }
                }

                Spacer()

                VStack {
                    Text(".time".localized())
                        .font(.caption)
                        .bold()
                    Text(infoTrack.getTimeAsString())
                }

                Spacer()

                VStack {
                    Text(".distance".localized())
                        .font(.caption)
                        .bold()
                    Text(infoTrack.distance.prepareString())
                }
            }
        }
        .padding(.all, 3)
    }
}
