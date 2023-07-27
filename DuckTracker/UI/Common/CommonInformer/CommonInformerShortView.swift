import SwiftUI

struct CommonInformerShortView: View {

    let type: CommonInformerType

    let messageText: String
    let messageImage: String

    let buttonText: String
    let buttonAction: () -> Void

    var backgroundColor: Color {
        switch type {
        case .success:
            return .commonInformerSuccess
        case .warning:
            return .commonInformerWarning
        case .danger:
            return .commonInformerDanger
        case .blue:
            return .commonInformerBlue
        case .orange:
            return .commonInformerOrange
        }
    }

    var body: some View {
        CommonStack(backgroundColor: backgroundColor) {
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: messageImage)
                    .resizable()
                    .frame(width: 70, height: 70)

                VStack(spacing: 4) {
                    Text(messageText)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(height: 38)

                    Button(action: buttonAction, label: {
                        Spacer()
                        Text(buttonText)
                        Spacer()
                    })
                    .buttonStyle(CommonInformerButtonStyle(type: type))
                }
            }
            .foregroundColor(Color.commonInformerText)
        }
    }
}

struct CommonInformerShortView_Previews: PreviewProvider {
    static var previews: some View {
        CommonInformerShortView(
            type: .success,
            messageText: "Super text for this caption.\nWelcome!",
            messageImage: "sportscourt.circle.fill",
            buttonText: "The Benjamin",
            buttonAction: {})
    }
}
