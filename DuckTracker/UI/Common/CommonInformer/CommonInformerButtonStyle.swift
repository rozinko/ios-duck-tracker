import Foundation
import SwiftUI

struct CommonInformerButtonStyle: ButtonStyle {

    var type: CommonInformerType

    var color: Color {
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

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(Font.title3.weight(.medium))
        }
        .padding([.top, .bottom], 2)
        .padding([.leading, .trailing], 10)
        .foregroundColor(color)
        .background(Color.commonInformerText)
        .shadow(radius: 10.0)
        .cornerRadius(10)
    }
}
