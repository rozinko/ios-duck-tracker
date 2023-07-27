import SwiftUI

struct ActiveTrackStartPauseResumeButtonView: View {

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    var body: some View {
        if activeTrackProvider.isRecording {

            // PAUSE BUTTON
            Button(action: {
                activeTrackProvider.pause()
            }, label: {
                HStack {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                    Text(".pause".localized().uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 41, maxHeight: 41, alignment: .center)
                .foregroundColor(Color.commonWhite)
                .background(Color.commonOrange)
            })
            // END OF PAUSE BUTTON

        } else if activeTrackProvider.track.trackPoints.isEmpty {

            // START BUTTON
            Button(action: {
                activeTrackProvider.start()
            }, label: {
                HStack {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                    Text(".start".localized().uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 41, maxHeight: 41, alignment: .center)
                .foregroundColor(Color.commonWhite)
                .background(Color.commonGreen)
            })
            // END OF START BUTTON

        } else {

            // RESUME BUTTON
            Button(action: {
                activeTrackProvider.start()
            }, label: {
                HStack {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                    Text(".resume".localized().uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 41, maxHeight: 41, alignment: .center)
                .foregroundColor(Color.commonWhite)
                .background(Color.commonGreen)
            })
            // END OF RESUME BUTTON

        }
    }
}

struct ActiveTrackStartPauseResumeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackStartPauseResumeButtonView()
    }
}
