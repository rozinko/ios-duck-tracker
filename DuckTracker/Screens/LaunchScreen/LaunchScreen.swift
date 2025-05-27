import SwiftUI
import DotLottie

struct LaunchScreen: View {

    @Binding var isLaunchScreenShowed: Bool

    @State var dotLottieView: DotLottieView?

    let appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "no ver"
    let appBuild: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "no build"

    @State var opacity: CGFloat = 0.0
    @State var linearGradient = LinearGradient(colors: [Color("launchBackgroundBottom"), Color("launchBackgroundTop")], startPoint: .bottom, endPoint: .top)

    var body: some View {
        ZStack {
            HStack {}
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(linearGradient)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                if dotLottieView != nil {
                    dotLottieView?.frame(width: 250, height: 250)
                } else {
                    Spacer().frame(width: 250, height: 250)
                }

                Text("Duck Tracker")
                    .font(Font.system(.largeTitle).bold())
                    .foregroundColor(.commonOrange)
                    .opacity(opacity)

                Spacer()

                Text("version \(appVersion) build \(appBuild)")
                    .font(Font.footnote)
                    .foregroundColor(.commonOrange)
                    .opacity(opacity)
                    .padding(25)
            }
        }
        .onAppear {
            let lottieAnimation = DotLottieAnimation(fileName: "LaunchScreenAnimation", config: AnimationConfig(autoplay: true, loop: true))
            let lottieView = DotLottieView(dotLottie: lottieAnimation)
            let obs = LaunchScreenDotLottieObserver(isLaunchScreenShowed: $isLaunchScreenShowed)

            lottieView.subscribe(observer: obs)

            dotLottieView = lottieView

            withAnimation(.easeInOut(duration: 0.7)) {
                opacity = 1
                linearGradient = LinearGradient(colors: [Color("launchBackgroundBottom"), Color("launchBackgroundTop")], startPoint: .bottom, endPoint: .top)
            }
        }
    }
}

#Preview {
    LaunchScreen(isLaunchScreenShowed: .constant(true))
}
