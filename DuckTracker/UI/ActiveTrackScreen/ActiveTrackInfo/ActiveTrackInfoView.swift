import SwiftUI

struct ActiveTrackInfoView: View {

    @Binding var activeTrackType: ActiveTrackType

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                ActiveTrackInfoGPSView()
                ActiveTrackInfoTypeView(activeTrackType: $activeTrackType)
            }
            ZStack {
                TrackInfoCommonView(
                    distance: activeTrackProvider.track.distance,
                    avgSpeed: activeTrackProvider.track.avgSpeed,
                    maxSpeed: activeTrackProvider.track.maxSpeed,
                    timeString: activeTrackProvider.track.getTimeString(isRecording: activeTrackProvider.isRecording),
                    withSpacers: true
                )

                if activeTrackType.isPaceType {
                    // pace
                    TrackInfoCircleView(
                        title: ".pace".localized().uppercased(),
                        text: activeTrackProvider.track.getPaceAsString(isRecording: activeTrackProvider.isRecording),
                        unit: ".minkm".localized().uppercased())
                } else {
                    // speed
                    ActiveTrackInfoSpeedView()
                }
            }
        }
    }
}

struct ActiveTrackInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 1) {
            Spacer()
            ActiveTrackInfoView(activeTrackType: .constant(.hike))
        }
        .background(Color.commonBorder)
    }
}
