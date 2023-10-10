import Foundation
import SwiftUI

struct ButtonOrangeFilledStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(Font.title3.weight(.medium))
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 20)
        .foregroundColor(Color.commonWhite)
        .background(Color.commonOrange)
        .shadow(radius: 10.0)
        .cornerRadius(15)
    }
}

struct ButtonOrangeFilledBlockStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(Font.title3.weight(.medium))
            Spacer()
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 20)
        .foregroundColor(Color.commonWhite)
        .background(Color.commonOrange)
        .shadow(radius: 10.0)
        .cornerRadius(15)
    }
}
