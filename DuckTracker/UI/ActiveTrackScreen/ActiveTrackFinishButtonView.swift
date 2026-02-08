import SwiftUI

struct ActiveTrackFinishButtonView: View {

    @Binding var showFinishModalView: Bool

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    var showFinishButton: Bool { !activeTrackProvider.isRecording && !activeTrackProvider.track.trackPoints.isEmpty }

    var body: some View {

        let offset: CGFloat = showFinishButton ? 60.0 : -150.0

        if #available(iOS 26.0, *) {
            Button(action: {
                showFinishModalView = true
            }, label: {
                Text(".finish".localized().uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 10)
            })
            .shadow(radius: 10.0)
            .clipShape(.capsule)
            .buttonStyle(.glassProminent)
            .tint(Color.commonOrange)
            .offset(y: offset)
            .animation(Animation.easeInOut(duration: 0.5), value: offset)
        } else {
            Button(action: {
                showFinishModalView = true
            }, label: {
                Text(".finish".localized().uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 10)
            })
            .shadow(radius: 10.0)
//            .clipShape(.capsule)
//            .buttonStyle(ButtonOrangeFilledStyle())
            .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 41, maxHeight: 41, alignment: .center)
            .foregroundColor(Color.commonWhite)
            .background(Color.commonOrange)
            .clipShape(.capsule)
            .offset(y: offset)
            .animation(Animation.easeInOut(duration: 0.5), value: offset)
        }

    }
}

struct TrackFinishButton_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackFinishButtonView(showFinishModalView: .constant(false))
    }
}
