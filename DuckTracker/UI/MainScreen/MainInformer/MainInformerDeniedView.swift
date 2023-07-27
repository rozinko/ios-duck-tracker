import SwiftUI

struct MainInformerDeniedView: View {

    var body: some View {
        CommonInformerView(
            type: .danger,
            size: .full,
            messageText: "MainInformer.denied.text".localized(),
            messageImage: "xmark.circle.fill",
            buttonText: "MainInformer.denied.button".localized(),
            buttonAction: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
    }
}

struct MainInformerDeniedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainInformerDeniedView()
        }.padding()
    }
}
