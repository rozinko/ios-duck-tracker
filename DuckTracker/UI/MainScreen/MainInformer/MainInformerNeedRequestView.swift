import SwiftUI

struct MainInformerNeedRequestView: View {

    var locationProvider = LocationProvider.shared

    var body: some View {
        CommonInformerView(
            type: .blue,
            size: .full,
            messageText: "MainInformer.needRequest.text".localized(),
            messageImage: "location.circle.fill",
            buttonText: "MainInformer.needRequest.button".localized(),
            buttonAction: {
                locationProvider.requestAuthorization()
            })
    }
}

struct MainInformerNeedRequestView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainInformerNeedRequestView()
        }.padding()
    }
}
