import SwiftUI

struct CommonStack<Content: View>: View {

    var backgroundColor: Color?
    var shadowColor: Color?
    var shadowRadius: CGFloat = 3
    var cornerRadius: CGFloat = 15

    @ViewBuilder var content: Content

    var realBackgroundColor: Color { backgroundColor ?? .commonElementBackground }
    var realShadowColor: Color { shadowColor ?? backgroundColor ?? .commonShadow }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(realBackgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: realShadowColor, radius: shadowRadius)
    }
}

struct CommonStack_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            CommonStack(backgroundColor: .yellow) {
                Text("Test text.")
            }

            CommonStack(backgroundColor: .red, shadowColor: .green, shadowRadius: 10) {
                Text("Test text.")
            }

            CommonStack(backgroundColor: .blue, cornerRadius: 25) {
                Text("Test text.")
            }

            CommonStack {
                Text("Test text.")
            }
        }
    }
}
