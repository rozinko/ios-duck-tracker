import SwiftUI
import DotLottie

class LaunchScreenDotLottieObserver: Observer {

    @Binding var isLaunchScreenShowed: Bool

    init(isLaunchScreenShowed: Binding<Bool>) {
        self._isLaunchScreenShowed = isLaunchScreenShowed
    }

    func onLoop(loopCount: UInt32) {
        isLaunchScreenShowed = false
    }

    func onComplete() {}
    func onFrame(frameNo: Float) {}
    func onLoad() {}
    func onLoadError() {}
    func onPause() {}
    func onPlay() {}
    func onRender(frameNo: Float) {}
    func onStop() {}
}
