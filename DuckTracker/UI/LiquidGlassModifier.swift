import SwiftUI

struct LiquidGlassModifier: ViewModifier {

    let glassShape: any Shape // костыль для кастомного shape
    let shape: any Shape

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular, in: glassShape)
                .clipShape(AnyShape(shape))
        } else if #available(iOS 16.0, *) {
            content
                .background(Color.commonElementBackground.opacity(0.7))
                .clipShape(AnyShape(shape))
        } else {
            content
                .background(Color.commonElementBackground.opacity(0.7))
        }
    }
}

#Preview {
    ZStack {
        Color.yellow

        VStack {
            HStack {
                Image(systemName: "globe")
                Text("Hello world")
            }
            .padding()
            .modifier(LiquidGlassModifier(glassShape: .capsule, shape: .capsule))

            HStack {
                Image(systemName: "car")
                Text("Car")
            }
            .padding()
            .modifier(LiquidGlassModifier(glassShape: RoundedRectangle(cornerRadius: 10), shape: RoundedRectangle(cornerRadius: 5)))

            HStack {
                Image(systemName: "basket")
            }
            .padding()
            .modifier(LiquidGlassModifier(glassShape: .circle, shape: .circle))
        }
    }
}
