import SwiftUI

struct CommonInformerView: View {

    let type: CommonInformerType
    let size: CommonInformerSize

    let messageText: String
    let messageImage: String

    let buttonText: String
    let buttonAction: () -> Void

    var body: some View {
        switch size {
        case .short:
            CommonInformerShortView(
                type: type,
                messageText: messageText,
                messageImage: messageImage,
                buttonText: buttonText,
                buttonAction: buttonAction)
        case .full:
            CommonInformerFullView(
                type: type,
                messageText: messageText,
                messageImage: messageImage,
                buttonText: buttonText,
                buttonAction: buttonAction)
        }
    }
}

struct CommonInformerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CommonInformerView(
                type: .success,
                size: .short,
                messageText: "Super text for this caption.\nWelcome!",
                messageImage: "sportscourt.circle.fill",
                buttonText: "The Benjamin",
                buttonAction: {})

            CommonInformerView(
                type: .warning,
                size: .short,
                messageText: "Short text",
                messageImage: "basketball.circle.fill",
                buttonText: "Short!",
                buttonAction: {})

            CommonInformerView(
                type: .danger,
                size: .full,
                messageText: "Long text long text long text long text long text long text long text text long text long text long text long text",
                messageImage: "power.circle.fill",
                buttonText: "Long button text!",
                buttonAction: {})

            CommonInformerView(
                type: .blue,
                size: .short,
                messageText: "Simple text for test.",
                messageImage: "snowflake.circle.fill",
                buttonText: "Long button text!",
                buttonAction: {})

            CommonInformerView(
                type: .orange,
                size: .short,
                messageText: "Simple text for test.",
                messageImage: "pawprint.circle.fill",
                buttonText: "Long button text!",
                buttonAction: {})
        }
        .padding()
    }
}
