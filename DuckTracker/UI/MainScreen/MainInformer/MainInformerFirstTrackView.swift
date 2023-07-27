import SwiftUI

struct MainInformerFirstTrackView: View {

    @Binding var selectedTab: Int

    var body: some View {
        CommonInformerView(
            type: .success,
            size: .short,
            messageText: "MainInformer.firstTrack.text".localized(),
            messageImage: "checkmark.circle.fill",
            buttonText: "MainInformer.firstTrack.button".localized(),
            buttonAction: {
                self.selectedTab = 2
            })
    }
}

struct MainInformerFirstTrackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainInformerFirstTrackView(selectedTab: .constant(1))
        }.padding()
    }
}
