import SwiftUI

struct ActiveTrackFinishButtonView: View {

    @Binding var showFinishModalView: Bool

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    var showFinishButton: Bool { !activeTrackProvider.isRecording && !activeTrackProvider.track.trackPoints.isEmpty }

    var body: some View {

        let offset: CGFloat = showFinishButton ? 50.0 : -150.0

        Button(action: {
            showFinishModalView = true
        }, label: {
            Text(".finish".localized().uppercased())
                .font(.title2)
                .fontWeight(.bold)
                .frame(idealWidth: 160, maxWidth: 160, idealHeight: 21, maxHeight: 21, alignment: .center)
        })
        .shadow(radius: 10.0)
        .buttonStyle(ButtonOrangeFilledStyle())
        .offset(y: offset)
        .animation(Animation.easeInOut(duration: 0.5), value: offset)

    }
}

struct TrackFinishButton_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackFinishButtonView(showFinishModalView: .constant(false))
    }
}
